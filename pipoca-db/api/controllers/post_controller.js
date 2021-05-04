import { getDistance } from "geolib";
const { scrapeMetaTags } = require("../utils/paginate");
import ApiError from "../errors/api_error";
const Sequelize = require("sequelize");
const models = require("../models");

exports.index = async({ query }, res) => {
    try {
        const { lat, lng, search } = query;
        if (search && lat && lng) {
            const tag = await models.tag.findOne({ where: { hash: search } });
            const [rows, count] = await models.post_tag.findAndCountAll({
                where: { tag_id: tag.id },
                // include:[
                //     {
                //         model: models.user,
                //         as: "creator",
                //         attributes: {
                //             exclude: [
                //                 "createdAt",
                // "updatedAt",
                // "birthday",
                // "role_id",
                // "bio",
                // "password",
                //             ],
                //         },
                //     },
                // ]
            });
            return res
                .status(200)
                .send({ message: `🍿 Bago ${id}  para ti 🥳`, post_tags });
        }
        /**
         * TODO: this is the index to see all the posts update the isnear to enable commenting
         * figure out how to work with geometry in sequelize
         * return a status with point and excluded the coordinates of other users this is important
         * need to put limits and sort it
         */
    } catch (error) {
        return res.status(500).json({
            error: error.message,
        });
    }
};
exports.show = async({ params, query, decoded }, res, next) => {
    try {
        const { id } = params;
        const { lat, lng } = query;

        var posts = await models.post.findAll({
            where: { id: id },
            limit: 1,
            attributes: [
                "id",
                "content",
                "flags",
                "is_flagged",
                "createdAt",
                "coordinates", [
                    Sequelize.literal(
                        `(SELECT voted FROM post_votes WHERE user_id = ${id} AND post_id = post.id)`
                    ),
                    "vote"
                ],
                [
                    Sequelize.literal(
                        `(SELECT CAST(SUM(voted) AS INT)  fROM post_votes WHERE post_id = ${id})`
                    ),
                    "votes_total",
                ],
                [
                    Sequelize.literal(
                        `(SELECT CAST(COUNT(id) AS INT)  fROM comments WHERE post_id = ${id})`
                    ),
                    "comments_total",
                ],
            ],
            include: [{
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
                    model: models.link,
                    as: "links",
                    required: false,
                    attributes: ["url"],
                    through: { attributes: [] },
                },
            ],
        });

        if (!posts) {
            next(ApiError.badRequestException(`Bago ${id} não existe`));
            return;
        }

        let distance;
        if (lat && lng) {
            distance = getDistance({ latitude: lat, longitude: lng }, {
                latitude: posts.coordinates.coordinates[1],
                longitude: posts.coordinates.coordinates[0],
            });
        }
        let isNear;
        if (distance <= 950) isNear = true;
        if (distance > 950) isNear = false;



        //let linkInfo = {};

        //  let data = {};
        const rows = posts.map(function(row) {
            return row.toJSON()
        });
        // for (var newData of rows) {
        //     if (newData.links.length > 0) {
        //         const { url } = newData.links[0];

        //         linkInfo = await scrapeMetaTags(url);
        //     }
        //     data = {
        //         user_voted: vote ? true : false,
        //         user_vote: vote == null ? 0 : vote,
        //         user_isNear: isNear,
        //         info: {
        //             id: newData.id,
        //             content: newData.content,
        //             links: linkInfo,
        //             votes_total: newData.votes_total == null ? 0 : newData.votes_total,
        //             comments_total: newData.comments_total,
        //             flags: newData.flags,
        //             is_flagged: newData.is_flagged,
        //             created_at: newData.createdAt,
        //             creator: newData.creator,
        //         },
        //     };
        // }


        const post = { success: true, message: ` Bago ${id} para ti`, rows };

        return res.status(200).json(post);
    } catch (error) {
        return res.status(500).json(error);
        // next(
        //     ApiError.internalException("Não conseguiu se comunicar com o servidor")
        // );
        // return;
    }
};