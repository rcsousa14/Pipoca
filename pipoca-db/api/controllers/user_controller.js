const Sequelize = require('sequelize');
const { admin } = require('../utils/paginate');
const models = require('../models');


exports.index = async (req, res) => {
    try {
        const page = parseInt(req.query.page);
        const limit = 25;
        let attributes = { exclude: ['bio', 'role_id'] };
        let include = [{
            model: models.role,
            as: 'role',
            where: { role: "regular" },
            attributes: { exclude: ['createdAt', 'updatedAt', 'id'] }
        }];
        const model = models.user;
        const users = await admin(model, page, limit, attributes, include);
        

        return res.status(200).send({ message: "here is all the users admin", users });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

exports.show = async ({ decoded }, res) => {
    
    try {
        const karma_total = await models.user.findOne({
            group: ['user.id'],
            where: {
                id: decoded.id
            },
            attributes: [
               
                [Sequelize.cast(Sequelize.fn('SUM', Sequelize.col('posts->post_votes.voted')),'INT'), 'posts_votes_total'],
                [Sequelize.cast(Sequelize.fn('SUM', Sequelize.col('comments->comment_votes.voted')),'INT'), 'comments_votes_total'],
                [Sequelize.cast(Sequelize.fn('SUM', Sequelize.col('sub_comments->sub_comment_votes.voted')),'INT'), 'sub_comments_votes_total']

                
            ],
            include: [

                {
                    
                    model: models.post,
                    as: 'posts',
                    attributes: [],
                    include: [
                        {
                            model: models.post_vote,
                            as: 'post_votes',
                            attributes: []
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
                            attributes: [],
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
                            attributes: [],
                        }
                    ]

                },


            ],
        });
        const user = await models.user.findOne({
            group: ['user.id'],
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
                [Sequelize.cast(Sequelize.fn('COUNT', Sequelize.col('posts.content')),'INT'), 'user_posts_total'],
                [Sequelize.cast(Sequelize.fn('COUNT', Sequelize.col('comments.content')),'INT'), 'user_comments_total'],
                [Sequelize.cast(Sequelize.fn('COUNT', Sequelize.col('sub_comments.content')),'INT'), 'user_sub_comments_total'],
            ],
            include: [

                {
                    
                    model: models.post,
                    as: 'posts',
                    attributes: [],

                },
                {
                    model: models.comment,
                    as: 'comments',
                    attributes: [],

                },
                {
                    model: models.sub_comment,
                    as: 'sub_comments',
                    attributes: [],
                    
                },


            ],

            



        });

        return res.status(200).json({ message: "😁 Usuário foi encontrado", user, karma_total });
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
        const user = await models.user.update({ phone_number, phone_carrier, username, avatar, birthday, bio, fcm_token }, {
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

