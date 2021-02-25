import { getDistance } from 'geolib';
const Sequelize = require("sequelize");
const models = require("../models");

exports.index = async({ query }, res) => {
    try {
        const { lat, lng, search } = query;
        if (search && lat && lng) {
            const tag = await models.tag.findOne({ where: { hash: search } })
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
            })
            return res.status(200).send({ message: `🍿 Bago ${id}  para ti 🥳`, post_tags });
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
exports.show = async({ params, query, decoded }, res) => {
    try {
        const result = cache.get(`post_${decoded.id}`);
        if (result) {
            return res.status(200).json(result);
        }
        const { id } = params;
        const { lat, lng } = query;
        var posts = await models.post.findOne({
            distinct: true,
            raw: true,
            group: ["post.id", "creator.id"],
            where: { id: id },
            attributes: [
                'id',
                'content',
                'links',
                'flags',
                'is_flagged',
                'is_deleted',
                'createdAt',
                'coordinates',

                [Sequelize.literal(`(SELECT CAST(COUNT(id) AS INT)  fROM comments WHERE post_id = ${id})`), 'total'],

                [Sequelize.cast(Sequelize.fn('SUM', Sequelize.col('post_votes.voted')), 'INT'), 'votes_total'],
            ],
            include: [{
                    model: models.user,
                    as: "creator",
                    attributes: {
                        exclude: [
                            "createdAt",
                            "updatedAt",
                            "birthday",
                            "role_id",
                            "bio",
                            "password",
                        ],
                    },
                },
                {

                    model: models.post_vote,
                    as: 'post_votes',
                    attributes: [],
                    duplicating: false,
                    required: false

                },

            ],
        });

        if (!posts) {
            return res.status(400).send({ message: `🍿 Bago ${id}  nao existe` });
        }


        let distance;
        if (lat && lng) {
            distance = getDistance({ latitude: lat, longitude: lng }, { latitude: posts.coordinates.coordinates[1], longitude: posts.coordinates.coordinates[0] });
        }
        let isNear;
        if (distance <= 950) isNear = true;
        if (distance > 950) isNear = false;

        const votes = await models.post_vote.findOne({
            raw: true,
            where: { user_id: decoded.id, post_id: posts.id },
            attributes: {
                exclude: ["user_id", "post_id", "createdAt", "updatedAt", "id"],
            },
        });
        const { votes_total } = posts;
        const isVoted = votes ? true : false;


        let post = {

            user_voted: isVoted,
            user_vote: votes == null ? 0 : votes.voted,
            user_isNear: isNear,
            post: {

                id: posts.id,
                content: posts.content,
                links: posts.links,
                comments_total: posts.total,
                votes_total: votes_total == null ? 0 : votes_total, // == null ? 0 : posts.votes_total,
                flags: posts.flags,
                is_flagged: posts.is_flagged,
                is_deleted: posts.is_deleted,
                created_at: posts.createdAt,
                creator: posts.creator

            },
        };
        const data = { message: `🍿 Bago ${id}  para ti 🥳`, post };
        cache.set(`post_${decoded.id}`, data);

        return res.status(200).send(data);
    } catch (error) {
        return res.status(500).json({
            error: error.message,
        });
    }
};