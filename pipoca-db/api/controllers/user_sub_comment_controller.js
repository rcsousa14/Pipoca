import ApiError from "../errors/api_error";

const models = require("../models");
const Sequelize = require("sequelize");
const { paginate } = require("../utils/paginate");

exports.store = async({ params, body, decoded }, res, next) => {
    try {
        const { comment_id } = params;
        const { content, links, hashes, reply_to_id, longitude, latitude } = body;

        // const TODAY_START = new Date().setHours(0, 0, 0, 0);
        // const NOW = new Date();
        // const result = await models.sub_comment.findOne({
        //     where: {
        //         content: content,
        //         user_id: decoded.id,
        //         comment_id: comment_id,
        //         createdAt: {
        //             [Op.lt]: NOW,
        //             [Op.gt]: TODAY_START,
        //         },
        //     },
        // });
        // if (result) {
        //     next(ApiError.badRequestException("Ninguém gosta de spam"));
        //     return;
        // }
        return res.status(200).json({
                comment_id,
                body,

            })
            // var point = {
            //     type: "Point",
            //     coordinates: [longitude, latitude],
            //     crs: { type: "name", properties: { name: "EPSG:4326" } },
            // };

        // const sub_comment = await models.sub_comment.create({
        //     user_id: decoded.id,
        //     reply_to_id: reply_to_id,
        //     comment_id: comment_id,
        //     content: content,
        //     coordinates: point,
        // });

        // if (!hashes.length == 0 && hashes.length > 0) {
        //     for (var hash of hashes) {
        //         const [tag] = await models.tag.findOrCreate({
        //             where: { hash: hash },
        //         });

        //         await models.post_tag.create({
        //             sub_comment_id: sub_comment.id,
        //             tag_id: tag.id,
        //         });
        //     }
        // }
        // if (!links.length == 0 && links.length > 0) {
        //     const [link] = await models.link.findOrCreate({
        //         where: { url: links[0] },
        //     });

        //     await models.post_link.create({
        //         sub_comment_id: sub_comment.id,
        //         link_id: link.id,
        //     });
        // }

        // return res.status(201).send({
        //     success: true,
        //     message: " Sub comentário criado com sucesso!",
        // });
    } catch (error) {
        return res.status(500).send({ error })
            // next(
            //     ApiError.internalException("Não conseguiu se comunicar com o servidor")
            // );
            // return;
    }
};

exports.index = async({ params, query, decoded }, res, next) => {
    try {
        const { comment_id } = params;
        const { lat, lng } = query;
        const id = decoded.id;
        const page = parseInt(query.page);
        const limit = 4;
        let group = ["sub_comment.id"];
        let search = {
            where: { comment_id: comment_id },
        };
        let order = [];

        order.push([Sequelize.literal("votes_total ASC")]);

        let attributes = [
            "id",
            "content",
            "flags",
            "is_flagged",
            "createdAt",

            "coordinates", [
                Sequelize.literal(
                    `(SELECT voted FROM sub_comment_votes WHERE user_id = ${id} AND sub_comment_id = sub_comment.id)`
                ),
                "vote",
            ],
            [
                Sequelize.literal(
                    `(SELECT CAST(SUM(voted) AS INT)  fROM sub_comment_votes WHERE sub_comment_id = sub_comment.id)`
                ),
                "votes_total",
            ],
        ];
        let include = [{
                model: models.user,
                as: "creator",
                attributes: {
                    exclude: [
                        "createdAt",
                        "updatedAt",
                        "deleted_at",
                        "birthday",
                        "reset_password_token",
                        "reset_password_expiration",
                        "refresh_token",
                        "role_id",
                        "bio",
                        "type",
                        "password",
                    ],
                },
            },
            {
                model: models.user,
                as: "replyTo",
                attributes: {
                    exclude: [
                        "createdAt",
                        "updatedAt",
                        "deleted_at",
                        "birthday",
                        "reset_password_token",
                        "reset_password_expiration",
                        "refresh_token",
                        "role_id",
                        "bio",
                        "type",
                        "password",
                        "email",
                        "avatar",
                        "active",
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
        const model = models.sub_comment;
        const bagos = await paginate(
            model,

            page,
            limit,
            search,
            order,
            attributes,
            include,
            group,
            lat,
            lng
        );
        const data = {
            success: true,
            message: "Todos os sub comentários ",
            bagos,
        };

        return res.status(200).send(data);
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};

exports.soft = async({ params, decoded }, res, next) => {
    try {
        await models.sub_comment.destroy({
            where: {
                userId: decoded.id,
                id: params.id,
            },
        });

        return res.status(200).send({
            success: true,
            message: `Sub comentário ${params.id} foi eliminado com sucesso`,
        });
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};

exports.show = async({ query, decoded }, res, next) => {
    try {
        const page = parseInt(query.page);
        const { lat, lng } = query;
        const limit = 9;
        const id = decoded.id;
        let search = { user_id: id };
        let group = ["sub_comment.id", "creator.id"];
        let order = [
            ["createdAt", "DESC"]
        ];
        let attributes = [
            "id",
            "content",
            "flags",
            "is_flagged",
            "createdAt",
            "coordinates", [
                Sequelize.literal(
                    `(SELECT voted FROM sub_comment_votes WHERE user_id = ${id} AND sub_comment_id = sub_comment.id)`
                ),
                "vote",
            ],
            [
                Sequelize.literal(
                    `(SELECT CAST(SUM(voted) AS INT)  fROM sub_comment_votes WHERE sub_comment_id = sub_comment.id)`
                ),
                "votes_total",
            ],
        ];
        let include = [{
                model: models.user,
                as: "creator",
                attributes: {
                    exclude: [
                        "createdAt",
                        "updatedAt",
                        "deleted_at",
                        "birthday",
                        "reset_password_token",
                        "reset_password_expiration",
                        "refresh_token",
                        "role_id",
                        "bio",
                        "type",
                        "password",
                    ],
                },
            },
            {
                model: models.user,
                as: "replyTo",
                attributes: {
                    exclude: [
                        "createdAt",
                        "updatedAt",
                        "deleted_at",
                        "birthday",
                        "reset_password_token",
                        "reset_password_expiration",
                        "refresh_token",
                        "role_id",
                        "bio",
                        "type",
                        "password",
                        "email",
                        "avatar",
                        "active",
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
        const model = models.sub_comment;
        const bagos = await paginate(
            model,

            page,
            limit,
            search,
            order,
            attributes,
            include,
            group,
            lat,
            lng
        );
        const data = {
            success: true,
            message: "Todos os teus sub comentários!",
            bagos,
        };

        return res.status(200).send(data);
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};