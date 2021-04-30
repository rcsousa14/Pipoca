import ApiError from "../errors/api_error";

const models = require("../models");
const Sequelize = require("sequelize");
const { paginate } = require("../utils/paginate");

const Op = Sequelize.Op;

exports.store = async({ params, body, decoded }, res, next) => {
    try {
        const { postId } = params;
        const { content, links, hashes, longitude, latitude } = body;
        const TODAY_START = new Date().setHours(0, 0, 0, 0);
        const NOW = new Date();
        const result = await models.comment.findOne({
            where: {
                content: content,
                user_id: decoded.id,
                createdAt: {
                    [Op.gt]: NOW,
                    [Op.lt]: TODAY_START,
                }
            }
        });
        if (result) {
            next(ApiError.badRequestException("Ninguém gosta de spam"));
            return;
        }
        var point = {
            type: "Point",
            coordinates: [longitude, latitude],
            crs: { type: "name", properties: { name: "EPSG:4326" } },
        };

        const comment = await models.comment.create({
            user_id: decoded.id,
            post_id: postId,
            content,
            coordinates: point,
        });

        if (!hashes.length == 0 && hashes.length > 0) {
            for (var hash of hashes) {
                const [tag] = await models.tag.findOrCreate({
                    where: { hash: hash },
                });

                await models.post_tag.create({
                    comment_id: comment.id,
                    tag_id: tag.id,
                });
            }
        }
        if (!links.length == 0 && links.length > 0) {
            const [link] = await models.link.findOrCreate({
                where: { url: links[0] },
            });

            await models.post_link.create({
                comment_id: comment.id,
                link_id: link.id,
            });
        }

        return res.status(201).json({
            success: true,
            message: "Comentário criado com sucesso!",
        });
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};

exports.index = async({ params, query, decoded }, res, next) => {
    try {

        const filtro = "comment";
        const { postId } = params;
        const { lat, lng } = query;
        const id = decoded.id;
        const page = parseInt(query.page);
        const limit = 15;
        let search = { post_id: postId };

        let order = [];
        let group = ["comment.id"];
        if (query.filter == "date") {
            order.push(["createdAt", "DESC"]);
        }
        if (query.filter == "pipocar") {
            order.push(
                [Sequelize.literal("votes_total ASC")], [Sequelize.literal("comments_total ASC")]
            );
        }
        if (query.filter == "date") {
            order.push(["createdAt", "DESC"]);
        }
        let attributes = [
            "id",
            "content",
            "flags",
            "is_flagged",
            "is_deleted",
            "createdAt",
            "coordinates", [
                Sequelize.literal(
                    `(SELECT CAST(SUM(voted) AS INT)  fROM comment_votes WHERE comment_id = comment.id)`
                ),
                "votes_total",
            ],
            [
                Sequelize.literal(
                    `(SELECT CAST(COUNT(id) AS INT)  fROM sub_comments WHERE comment_id = comment.id)`
                ),
                "comments_total",
            ],
        ];
        let include = [{
                model: models.user,
                as: "creator",
                attributes: {
                    exclude: [
                        "createdAt",
                        "updatedAt",
                        "birthday",
                        "reset_password_token",
                        "reset_assword_expiration",
                        "refresh_token",
                        "role_id",
                        "bio",
                        "password",
                    ],
                },
            },
            {
                model: models.link,
                as: "links",
                required: false,
                attributes: ["url"],
                through: { attributes: [] },
            },
        ];
        const model = models.comment;
        const comments = await paginate(
            model,
            id,
            page,
            limit,
            search,
            order,
            attributes,
            include,
            group,
            lat,
            lng,
            filtro
        );
        const data = {
            success: true,
            message: "Todos os comentários",
            comments,
        };

        return res.status(200).json(data);
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};

exports.soft = async({ params, decoded }, res, next) => {
    try {
        const updated = await models.comment.update({
            is_deleted: true,
        }, {
            where: {
                user_id: decoded.id,
                id: params.id,
            },
        });
        if (updated) {

            return res.status(200).json({
                success: true,
                message: `Comentário ${id} foi eliminado com sucesso`,
            });
        } else {
            next({});
            return;
        }
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};

exports.show = async({ query, decoded }, res, next) => {
    try {

        const filtro = "comment";
        const { lat, lng } = query;
        const id = decoded.id;
        const page = parseInt(query.page);
        const limit = 10;

        let search = { user_id: id, is_deleted: false };
        let order = [
            ["createdAt", "DESC"]
        ];
        let group = ["comment.id", "creator.id"];
        let attributes = [
            "id",
            "content",
            "flags",
            "is_flagged",
            "is_deleted",
            "createdAt",
            "coordinates", [
                Sequelize.literal(
                    `(SELECT CAST(SUM(voted) AS INT)  fROM comment_votes WHERE comment_id = comment.id)`
                ),
                "votes_total",
            ],
            [
                Sequelize.literal(
                    `(SELECT CAST(COUNT(id) AS INT)  fROM sub_comments WHERE comment_id = comment.id)`
                ),
                "comments_total",
            ],
        ];

        let include = [{
                model: models.user,
                as: "creator",
                attributes: {
                    exclude: [
                        "createdAt",
                        "updatedAt",
                        "birthday",
                        "reset_password_token",
                        "reset_password_expiration",
                        "refresh_token",
                        "role_id",
                        "bio",
                        "password",
                    ],
                },
            },
            {
                model: models.link,
                as: "links",
                required: false,
                attributes: ["url"],
                through: { attributes: [] },
            },
        ];
        const model = models.comment;
        const comments = await paginate(
            model,
            id,
            page,
            limit,
            search,
            order,
            attributes,
            include,
            group,
            lat,
            lng,
            filtro
        );
        const data = {
            success: true,
            message: "Todos os teus comentários!",
            comments
        };

        return res.status(200).json(result);
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};