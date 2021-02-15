const models = require('../models');
const Sequelize = require('sequelize');
const { paginate } = require('../utils/paginate');

exports.store = async ({ params, body, decoded }, res) => {
    try {
        const { post_id } = params;
        const { content, links, longitude, latitude } = body;

        var point = {
            type: 'Point',
            coordinates: [longitude, latitude],

        };

        await models.comment.create({ user_id: decoded.id, post_id, content, links,  coordinates: point });

        return res.status(201).send({ message: '🍿 Commentario criado com sucesso! 🥳' })
    } catch (error) {
        return res.status(500).json({
            error: error.message
        })
    }
}

exports.index = async ({ params, query, decoded }, res) => {
    try {
        const filtro = 'comment';
        const { post_id } = params;
        const { lat, lng } = query;
        const id = decoded.id;
        const page = parseInt(query.page);
        const limit = 9;
        let search = { post_id: post_id };

        let order = [];
        let group = ['comment.id', 'creator.id'];
        if (query.filter == 'date') {
            order.push(
                ['createdAt', 'DESC']
            )
        }
        if (query.filter == 'pipocar') {
            order.push(
                [Sequelize.literal('votes_total ASC')],
                [Sequelize.literal('comments_total ASC')]
            );
        }
        if (query.filter == 'date') {
            order.push(['createdAt', 'DESC']);
        }
        let attributes = [
            'id',
            'content',
            'links',
            'flags',
            'is_flagged',
            'is_deleted',
            'createdAt',
            'coordinates',
            [Sequelize.literal(`(SELECT CAST(SUM(voted) AS INT)  fROM comment_votes WHERE comment_id = comment.id)`), 'votes_total'],
            [Sequelize.literal(`(SELECT CAST(COUNT(id) AS INT)  fROM sub_comments WHERE comment_id = comment.id)`), 'comments_total'],
        ];
        let include = [
            {
                model: models.user,
                as: 'creator',
                attributes: { exclude: ['createdAt', 'updatedAt', 'phone_number', 'phone_carrier', 'birthday', 'role_id', 'bio'] }
            },


        ];
        const model = models.comment;
        const comments = await paginate(model, id, page, limit, search, order, attributes, include, group, lat, lng, filtro);

        return res.status(200).send({ message: '🍿 Todos os Commentarios proximo de ti 🥳', comments });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        })
    }
}

exports.soft = async ({ params, decoded }, res) => {
    try {

        await models.comment.update({
            is_deleted: true
        }, {
            where: {
                user_id: decoded.id,
                post_id: params.id
            }
        });
        return res.status(200).send({ message: `Commentario ${id} foi eliminado com sucesso` });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}

exports.show = async ({ query, decoded }, res) => {
    try {
        const filtro = 'comment';
        const { lat, lng } = query;
        const id = decoded.id;
        const page = parseInt(query.page);
        const limit = 9;

        let search = { user_id: id };
        let order = [
            ['createdAt', 'DESC']
        ];
        let group = ['comment.id', 'creator.id'];
        let attributes = [
            'id',
            'content',
            'links',
            'flags',
            'is_flagged',
            'is_deleted',
            'createdAt',
            'coordinates',
            [Sequelize.literal(`(SELECT CAST(SUM(voted) AS INT)  fROM comment_votes WHERE comment_id = comment.id)`), 'votes_total'],
            [Sequelize.literal(`(SELECT CAST(COUNT(id) AS INT)  fROM sub_comments WHERE comment_id = comment.id)`), 'comments_total'],
        ];

        let include = [
            {
                model: models.user,
                as: 'creator',
                attributes: { exclude: ['createdAt', 'updatedAt', 'phone_number', 'phone_carrier', 'birthday', 'role_id', 'bio'] }
            },


        ];
        const model = models.comment;
        const comments = await paginate(model, id, page, limit, search, order, attributes, include, group, lat, lng, filtro);

        return res.status(200).send({ message: '🍿 Todos os teus Commentarios  🥳', comments });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}