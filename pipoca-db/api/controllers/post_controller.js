const Sequelize = require("sequelize");
const models = require("../models");

exports.index = async({ body, decoded }, res) => {
    try {
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
exports.show = async({ params, decoded }, res) => {
    try {
        const { id } = params;

        var posts = await models.post.findOne({
            group: ["post.id", "creator.id"],
            where: { id: id },
            attributes: [
                "id",
                "content",
                "links",
                "tags",
                "flags",
                "is_flagged",
                "createdAt", [Sequelize.cast(Sequelize.fn('COUNT', Sequelize.col('post_comments.id')), 'INT'), 'comments_total'],
                [Sequelize.cast(Sequelize.fn('SUM', Sequelize.col('post_votes.voted')), 'INT'), 'votes_total'],
            ],
            include: [{
                    model: models.user,
                    as: "creator",
                    attributes: {
                        exclude: [
                            "createdAt",
                            "updatedAt",
                            "phone_number",
                            "phone_carrier",
                            "birthday",
                            "role_id",
                        ],
                    },
                },
                {

                    model: models.post_vote,
                    as: 'post_votes',
                    attributes: [],

                },
                {
                    model: models.comment,
                    as: 'post_comments',
                    attributes: [],

                },
            ],
        });

        if (!posts)
            return res.status(401).send({ message: `🍿 Bago ${id}  nao existe` });
        const votes = await models.post_vote.findOne({
            raw: true,
            where: { user_id: decoded.id, post_id: posts.id },
            attributes: {
                exclude: ["user_id", "post_id", "createdAt", "updatedAt", "id"],
            },
        });
        const isVoted = votes ? true : false;

        let post = {
            user_voted: isVoted,
            user_vote: votes == null ? 0 : votes.voted,
            post_comments_total: posts.comments.total == null ? 0 : post_comments_total,
            post_votes_total: posts.votes.total == null ? 0 : posts.votes.total,
            post: posts,
        };

        return res.status(200).send({ message: `🍿 Bago ${id}  para ti 🥳`, post });
    } catch (error) {
        return res.status(500).json({
            error: error.message,
        });
    }
};