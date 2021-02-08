const Sequelize = require('sequelize');
const models = require('../models');


exports.index = async (req, res) => {
    try {
        const users = await models.user.findAll({
            attributes: { exclude: ['bio', 'role_id'] },
            include: [{
                model: models.role,
                as: 'role',
                where: { role: "regular" },
                attributes: { exclude: ['createdAt', 'updatedAt', 'id'] }
            }]
        });

        return res.status(200).send({ message: "here is all the users admin", users });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

exports.show = async ({ decoded }, res) => {
    /** 
     * TODO: this needs to include:
     * the total number of user posts
     * the total number of user comments
     * the total number of user subcomments
     * maybe try to combine them( see the ui first)
     * the total number of votes (post, comments, sub_comments)
    */
    try {
        const user = await models.user.findOne({
            group: ['user.id', 'posts.id', 'comments.id','posts->post_votes.id','comments->comment_votes.id','sub_comments->sub_comment_votes.id'],
            where: {
                id: decoded.id
            },
           
            attributes: [
                'id',
                'username',
                'bio',
                'phone_number',
                'avatar',
                'birthday',
                'fcm_token',
                'phone_carrier',
                'createdAt',
                [Sequelize.fn('COUNT', Sequelize.col('posts.id')), 'user_posts_total'],
                [Sequelize.fn('COUNT', Sequelize.col('comments.id')), 'user_comments_total'],
                [Sequelize.fn('COUNT', Sequelize.col('sub_comments.id')), 'user_sub_comments_total'],
                [Sequelize.fn('COUNT', Sequelize.col('sub_comments.id')), 'user_sub_comments_total'],
                [Sequelize.fn('SUM', Sequelize.col('posts->post_votes.voted')), 'user_posts_votes_total'],
                [Sequelize.fn('SUM', Sequelize.col('comments->comment_votes.voted')), 'user_comments_votes_total'],
                [Sequelize.fn('SUM', Sequelize.col('sub_comments->sub_comment_votes.voted')), 'user_sub_comments_votes_total']
            ],

            include: [

                {
                    
                    model: models.post,
                    as: 'posts',
                    attributes : [],
                    include: [
                        {
                            model: models.post_vote,
                            as: 'post_votes',
                            attributes : [],
                        }
                    ]

                },
                {
                    model: models.comment,
                    as: 'comments',
                    attributes: [],
                    include: [
                        {
                            model: models.comment_vote,
                            as: 'comment_votes',
                            attributes : [],
                        }
                    ]

                },
                {
                    model: models.sub_comment,
                    as: 'sub_comments',
                    attributes: [],
                    include: [
                        {
                            model: models.sub_comment_vote,
                            as: 'sub_comment_votes',
                            attributes : [],
                        }
                    ]

                },


            ],



        });
       
        return res.status(200).json({ message: "😁 Usuário foi encontrado", user});
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }



};

exports.destroy = async ({ decoded }, res) => {
    try {
        await models.user.destroy({
            where: {
                id: decoded.id
            }
        });
        return res.status(200).send({ message: "😞 Nós odiamos ver você ir. Volto logo! 🍿" });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }

};

exports.update = async ({ body, decoded }, res) => {
    try {
        // figure out how to patch instead
        const { phone_number, phone_carrier, username, avatar, birthday, bio, fcm_token } = body;
        const user = await models.user.update({phone_number, phone_carrier, username, avatar, birthday, bio, fcm_token }, {
            where: {
                id: decoded.id
            },

        });

        return res.status(200).send({ message: "🍿 So sucesso! de volta a pipocar 😆", user });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }

};

