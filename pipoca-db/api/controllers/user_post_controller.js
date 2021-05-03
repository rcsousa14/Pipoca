import ApiError from "../errors/api_error";

const { paginate } = require("../utils/paginate");
const models = require("../models");
const Sequelize = require("sequelize");

const Op = Sequelize.Op;

exports.store = async({ body, decoded }, res, next) => {
    try {
        const { content, links, hashes, longitude, latitude } = body;

        const TODAY_START = new Date().setHours(0, 0, 0, 0);
        const NOW = new Date();
        const result = await models.post.findOne({
            where: {
                content: content,
                user_id: decoded.id,
                createdAt: {
                    [Op.gt]: NOW,
                    [Op.lt]: TODAY_START,
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

        const post = await models.post.create({
            user_id: decoded.id,
            content,
            coordinates: point,
        });
        if (!hashes.length == 0 && hashes.length > 0) {
            for (var hash of hashes) {
                const [tag] = await models.tag.findOrCreate({
                    where: { hash: hash },
                });

                await models.post_tag.create({ post_id: post.id, tag_id: tag.id });
            }
        }
        if (!links.length == 0 && links.length > 0) {
            const [link] = await models.link.findOrCreate({
                where: { url: links[0] },
            });

            await models.post_link.create({ post_id: post.id, link_id: link.id });
        }

        return res.status(201).json({
            success: true,
            message: "Bago criado com sucesso!",
        });
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};
//feed shows all posts that are near by you can sort it for posts with higher points
exports.index = async({ query, decoded }, res, next) => {
    try {
        const filtro = "post";
        const { lat, lng } = query;
        const id = decoded.id;
        const page = parseInt(query.page);
        const limit = 25;

        let search;
        let order = [];

        const NOW = new Date();
        const TODAY_START = new Date(Date.now() - 3 * 24 * 60 * 60 * 1000);

        if (lat && lng) {
            if (query.filter == "pipocar") {
                search = {
                    is_deleted: false,
                    created_at: {
                        [Op.lt]: NOW,
                        [Op.gt]: TODAY_START,
                    },
                    [Op.and]: Sequelize.where(
                        Sequelize.fn(
                            "ST_DWithin",
                            Sequelize.col("post.coordinates"),
                            Sequelize.fn(
                                "ST_SetSRID",
                                Sequelize.fn("ST_MakePoint", lng, lat),
                                4326
                            ),
                            950
                        ),
                        true
                    ),

                    /**
                                                             * for location-post
                                                             * Sequelize.where(
                                                             Sequelize.fn('ST_Contains',
                                                                Sequelize.col('location.poly'),
                                                                Sequelize.fn('ST_SetSRID',
                                                                    Sequelize.fn('ST_MakePoint',
                                                                        lng, lat),
                                                                    4326),
                                                                950),
                                                            true)
                                                             */
                };
            }
            if (query.filter == "date") {
                search = {
                    is_deleted: false,
                    [Op.and]: Sequelize.where(
                        Sequelize.fn(
                            "ST_DWithin",
                            Sequelize.col("post.coordinates"),
                            Sequelize.fn(
                                "ST_SetSRID",
                                Sequelize.fn("ST_MakePoint", lng, lat),
                                4326
                            ),
                            950
                        ),
                        true
                    ),
                };
            }
        }
        let group = ["post.id"];
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
            "coordinates",

            [
                Sequelize.literal(
                    `(SELECT CAST(SUM(voted) AS INT)  fROM post_votes WHERE post_id = post.id)`
                ),
                "votes_total",
            ],
            [
                Sequelize.literal(
                    `(SELECT CAST(COUNT(id) AS INT)  fROM comments WHERE post_id = post.id)`
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
        const model = models.post;
        const posts = await paginate(
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
            message: "Todos os Bagos proximo de ti",
            posts,
        };

        return res.status(200).json(data);
    } catch (error) {
        return res.status(500).json({ error });
        // next(
        //     ApiError.internalException("Não conseguiu se comunicar com o servidor")
        // );
        // return;
    }
};
// deletes users posts
exports.soft = async({ params, decoded }, res, next) => {
    try {
        const { id } = params;
        const updated = await models.post.update({
            is_deleted: false,
        }, {
            where: {
                id: id,
                user_id: decoded.id,
            },
        });
        if (updated) {} else {
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
// shows all posts by user
exports.show = async({ query, decoded }, res, next) => {
    try {
        if (result) {
            return res.status(200).json(result);
        }
        const filtro = "post";
        const { lat, lng } = query;
        const id = decoded.id;
        const page = parseInt(query.page);
        const limit = 10;

        let search = { user_id: decoded.id, is_deleted: false };
        let order = [
            ["createdAt", "DESC"]
        ];
        let group = ["post.id", "creator.id"];
        let attributes = [
            "id",
            "content",
            "flags",
            "is_flagged",
            "is_deleted",
            "createdAt",
            "coordinates", [
                Sequelize.literal(
                    `(SELECT CAST(SUM(voted) AS INT)  fROM post_votes WHERE post_id = post.id)`
                ),
                "votes_total",
            ],
            [
                Sequelize.literal(
                    `(SELECT CAST(COUNT(id) AS INT)  fROM comments WHERE post_id = post.id)`
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
        const model = models.post;
        const posts = await paginate(
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
            message: `Todos os teu Bagos!`,
            posts,
        };

        return res.status(200).json(data);
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};