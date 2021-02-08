const models = require('../models');
const Sequelize = require('sequelize');

exports.store = async ({ body, decoded }, res) => {
    try {
        const { content, links, tags, longitude, latitude } = body;

        var point = {
            type: 'Point',
            coordinates: [longitude, latitude],

        };

        await models.post.create({ user_id: decoded.id, content, links, tags, flags: 0, coordinates: point })

        return res.status(201).send({ message: '🍿 Bago criado com sucesso! 🥳' });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

exports.index = async ({ query }, res) => {
    try {
        /**
         * TODO: this is the index to see all the post that are nearby (user perspective)
         * 
         * 
         * in the includes i need to add the karma total and post total
         * find it withing 4.5km
         * query is like this ?lat=0&lng=0
         * im here
         */
        const { lat, lng } = query;
        var posts = await models.post.findAll({
            where: Sequelize.where(
                Sequelize.fn('ST_DWithin',
                    Sequelize.col('coordinates'),
                    Sequelize.fn('ST_SetSRID',
                        Sequelize.fn('ST_MakePoint',
                            lng, lat),
                        4326),
                    0.032),
                true),
            attributes: { exclude: ['coordinates', 'user_id'] },
            include: [
                {
                    model: models.user,
                    as: 'user_post',
                    attributes: { exclude: ['createdAt', 'updatedAt', 'phone_number', 'phone_carrier', 'birthday', 'role_id'] }
                }
            ]
        });

        return res.status(200).send({ message: '🍿 Todos os Bagos proximo de ti 🥳', posts });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

exports.destroy = async ({ params, decoded }, res) => {
    try {
        const { id } = params;
        /**
         * TODO: check if there is find and destroy
         */
        await models.post.destroy({
            where: {
                id: id,
                user_id: decoded.id
            }
        });
        return res.status(200).send({ message: `Bago ${id} foi eliminado com sucesso` });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}

exports.show = async ({ decoded }, res) => {
    try {
        const posts = await models.post.findAll({
            group: ['post.id','user_post.id', 'post_comments.id', 'post_votes.id'],
            where: { user_id: decoded.id },
            attributes: [
                'id',
                'content',
                'links',
                'tags',
                'flags',
                'is_flagged',
                'createdAt',
                [Sequelize.fn('COUNT', Sequelize.col('post_comments.id')), 'post_comments_total'],
                [Sequelize.fn('SUM', Sequelize.col('post_votes.voted')), 'posts_votes_total'],
            ],
            include: [
                {
                    model: models.user,
                    as: 'user_post',
                    attributes: { exclude: ['createdAt', 'updatedAt', 'phone_number', 'phone_carrier', 'birthday', 'role_id'] }
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
            ]

        });
        return res.status(200).send({ message: `Aqui esta todos os teu Bagos! 🍿`, posts });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}