import ApiError from "../errors/api_error";
import { getDistance } from "geolib";
const { scrapeMetaTags } = require("../utils/paginate");
const models = require("../models");
const Sequelize = require("sequelize");
const { paginate } = require("../utils/paginate");

const Op = Sequelize.Op;

exports.single = async({ params, query, decoded }, res, next) => {
    try {
        const { id } = params;
        const { lat, lng } = query;
        const comment = await models.comment.findOne({
            where: { id: id },
            distinct: true,
            attributes: [
                "id",
                "content",
                "flags",
                "is_flagged",
                "createdAt",
                "coordinates", [
                    Sequelize.fn(
                        "ST_Distance",
                        Sequelize.col("coordinates"),
                        Sequelize.fn(
                            "ST_SetSRID",
                            Sequelize.fn("ST_MakePoint", lng, lat),
                            4326
                        )
                    ),
                    "distance",
                ],
                [
                    Sequelize.literal(
                        `(SELECT voted FROM comment_votes WHERE user_id = ${decoded.id} AND comment_id = ${id})`
                    ),
                    "vote",
                ],
                [
                    Sequelize.literal(
                        `(SELECT CAST(SUM(voted) AS INT)  fROM comment_votes WHERE comment_id = ${id})`
                    ),
                    "votes_total",
                ],
                [
                    Sequelize.literal(
                        `(SELECT CAST(COUNT(id) AS INT)  fROM sub_comments WHERE comment_id = ${id})`
                    ),
                    "comments_total",
                ],
            ],
            include: [{
                    model: models.user,
                    as: "creator",
                    attributes: {
                        exclude: [
                            "email",
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
                    model: models.link,
                    as: "links",
                    required: false,
                    attributes: ["url"],
                    through: { attributes: [] },
                },
            ],
        });
        if (!comment) {
            next(ApiError.badRequestException(`Comentário ${id} não existe`));
            return;
        }
        let distance;
        if (lat && lng) {
            distance = getDistance({ latitude: lat, longitude: lng }, {
                latitude: comment.coordinates.coordinates[1],
                longitude: comment.coordinates.coordinates[0],
            });
        }
        let isNear;
        if (distance <= 2500) isNear = true;
        if (distance > 2500) isNear = false;

        let linkInfo = {};

        if (comment.links.length > 0) {
            const { url } = comment.links[0];

            linkInfo = await scrapeMetaTags(url);
        }
        let newData = comment.get({ plain: true });

        let data = {
            user_voted: newData["votes"] ? false : true,
            user_vote: newData["votes"] == null ? null : newData["votes"],
            user_isNear: isNear,
            reply_to: null,
            // distance: newData['distance'] * 111, //km
            info: {
                id: newData["id"],
                content: newData["content"],
                links: linkInfo,
                votes_total: newData["votes_total"],
                comments_total: newData["comments_total"],
                flags: newData["flags"],
                is_flagged: newData["is_flagged"],
                created_at: newData["createdAt"],
                creator: newData["creator"],
            },
        };

        const post = {
            success: true,
            message: `Comentário ${id} para ti`,
            data
        };
        return res.status(200).json(post);
    } catch (error) {

        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};

exports.store = async({ params, body, decoded }, res, next) => {
    try {
        const { post_id } = params;
        const { content, links, hashes, longitude, latitude } = body;
        const TODAY_START = new Date().setHours(0, 0, 0, 0);
        const NOW = new Date();
        const result = await models.comment.findOne({
            where: {
                content: content,
                user_id: decoded.id,
                post_id: post_id,
                createdAt: {
                    [Op.lt]: NOW,
                    [Op.gt]: TODAY_START,
                },
            },
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
            post_id: post_id,
            content: content,
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
        const { post_id } = params;
        const { lat, lng } = query;
        const id = decoded.id;
        const page = parseInt(query.page);

        const limit = 15;
        let search = { post_id: post_id };

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

        let attributes = [
            "id",
            "content",
            "flags",
            "is_flagged",
            "createdAt",
            "coordinates", [
                Sequelize.fn(
                    "ST_Distance",
                    Sequelize.col("coordinates"),
                    Sequelize.fn(
                        "ST_SetSRID",
                        Sequelize.fn("ST_MakePoint", lng, lat),
                        4326
                    )
                ),
                "distance",
            ],
            [
                Sequelize.literal(
                    `(SELECT voted FROM comment_votes WHERE user_id = ${id} AND comment_id = comment.id)`
                ),
                "vote",
            ],
            [
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
                        "email",
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
                model: models.link,
                as: "links",
                required: false,
                attributes: ["url"],
                through: { attributes: [] },
            },
        ];
        const model = models.comment;
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
            message: "Todos os comentários",
            bagos,
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
        const updated = await models.comment.destroy({
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
        const { lat, lng } = query;
        const id = decoded.id;
        const page = parseInt(query.page);
        const limit = 10;

        let search = { user_id: id };
        let order = [
            ["createdAt", "DESC"]
        ];
        let group = ["comment.id", "creator.id"];
        let attributes = [
            "id",
            "content",
            "flags",
            "is_flagged",
            "createdAt",
            "coordinates", [
                Sequelize.fn(
                    "ST_Distance",
                    Sequelize.col("coordinates"),
                    Sequelize.fn(
                        "ST_SetSRID",
                        Sequelize.fn("ST_MakePoint", lng, lat),
                        4326
                    )
                ),
                "distance",
            ],
            [
                Sequelize.literal(
                    `(SELECT voted FROM comment_votes WHERE user_id = ${id} AND comment_id = comment.id)`
                ),
                "vote",
            ],
            [
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
                        "email",
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
                model: models.link,
                as: "links",
                required: false,
                attributes: ["url"],
                through: { attributes: [] },
            },
        ];
        const model = models.comment;
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
            message: "Todos os teus comentários!",
            bagos,
        };

        return res.status(200).json(data);
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};