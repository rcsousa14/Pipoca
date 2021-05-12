import { getDistance } from "geolib";
const { scrapeMetaTags } = require("../utils/paginate");
import ApiError from "../errors/api_error";
const Sequelize = require("sequelize");
const models = require("../models");


exports.show = async({ params, query, decoded }, res, next) => {
    try {
        const { id } = params;
        const { lat, lng } = query;

        const posts = await models.post.findOne({
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
                        ),

                    ), "distance",

                ],
                [
                    Sequelize.literal(
                        `(SELECT voted FROM post_votes WHERE user_id = ${decoded.id} AND post_id = ${id})`
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



        let linkInfo = {};




        if (posts.links.length > 0) {
            const { url } = posts.links[0];

            linkInfo = await scrapeMetaTags(url);
        }
        let newData = posts.get({ plain: true });

        let data = {
            user_voted: newData['votes'] == null ? false : true,
            user_vote: newData['votes'] == null ? 0 : newData['votes'],
            user_isNear: isNear,
            reply_to: "",
            distance: newData['distance'],
            info: {
                id: newData['id'],
                content: newData['content'],
                links: linkInfo,
                votes_total: newData['votes_total'] == null ? 0 : newData['votes_total'],
                comments_total: newData['comments_total'],
                flags: newData['flags'],
                is_flagged: newData['is_flagged'],
                created_at: newData['createdAt'],
                creator: newData['creator'],
            }
        }





        const post = {
            success: true,
            message: ` Bago ${id} para ti`,
            data,
        };

        return res.status(200).json(post);
    } catch (error) {

        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};