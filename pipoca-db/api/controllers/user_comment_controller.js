import CacheService from '../utils/cache';
const models = require('../models');
const Sequelize = require('sequelize');
const { paginate } = require('../utils/paginate');
const ttl = 10;
const cache = new CacheService(ttl);
const cachePost = new CacheService(60);

exports.store = async({ params, body, decoded }, res) => {
    try {
        const { post_id } = params;
        const { content, links, longitude, latitude } = body;
        const result = cachePost.get(`user_comment_${decoded.id}`);
        if (result && result == content) {
            console.log(result)
            return res.status(550).json({ message: '🖐🏾 Eh mano ninguem gosta de spam 👾' });
        }
        var point = {
            type: 'Point',
            coordinates: [longitude, latitude],

        };

        const comment = await models.comment.create({ user_id: decoded.id, post_id, content, links, coordinates: point });
        cachePost.set(`user_comment_${decoded.id}`, comment.content);
        cache.del(`user_comments_feed_${decoded.id}`);
        cache.del(`user_comments_${decoded.id}`);
        return res.status(201).send({ message: '🍿 Commentario criado com sucesso! 🥳' })
    } catch (error) {
        return res.status(500).json({
            error: error.message
        })
    }
}

exports.index = async({ params, query, decoded }, res) => {
    try {
        const result = cache.get(`user_comments_feed_${decoded.id}`);
        if (result) {
            return res.status(200).json(result);
        }
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
                [Sequelize.literal('votes_total ASC')], [Sequelize.literal('comments_total ASC')]
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
            'coordinates', [Sequelize.literal(`(SELECT CAST(SUM(voted) AS INT)  fROM comment_votes WHERE comment_id = comment.id)`), 'votes_total'],
            [Sequelize.literal(`(SELECT CAST(COUNT(id) AS INT)  fROM sub_comments WHERE comment_id = comment.id)`), 'comments_total'],
        ];
        let include = [{
                model: models.user,
                as: 'creator',
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
                    ]
                }
            },


        ];
        const model = models.comment;
        const comments = await paginate(model, id, page, limit, search, order, attributes, include, group, lat, lng, filtro);
        const data = { message: '🍿 Todos os commentarios proximo de ti 🥳', comments };
        cache.set(`user_comments_feed_${decoded.id}`, data);
        return res.status(200).send(data);


    } catch (error) {
        return res.status(500).json({
            error: error.message
        })
    }
}

exports.soft = async({ params, decoded }, res) => {
    try {

        await models.comment.update({
            is_deleted: true
        }, {
            where: {
                user_id: decoded.id,
                id: params.id
            }
        });
        cache.del(`user_comments_feed_${decoded.id}`);
        cache.del(`user_comments_${decoded.id}`);
        return res.status(200).send({ message: `Commentario ${id} foi eliminado com sucesso` });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}

exports.show = async({ query, decoded }, res) => {
    try {
        const result = cache.get(`user_comments_${decoded.id}`);
        if (result) {
            return res.status(200).json(result);
        }
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
            'coordinates', [Sequelize.literal(`(SELECT CAST(SUM(voted) AS INT)  fROM comment_votes WHERE comment_id = comment.id)`), 'votes_total'],
            [Sequelize.literal(`(SELECT CAST(COUNT(id) AS INT)  fROM sub_comments WHERE comment_id = comment.id)`), 'comments_total'],
        ];

        let include = [{
                model: models.user,
                as: 'creator',
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
                    ]
                }
            },


        ];
        const model = models.comment;
        const comments = await paginate(model, id, page, limit, search, order, attributes, include, group, lat, lng, filtro);
        const data = { message: '🍿 Todos os teus sub commentarios  🥳', comments };
        cache.set(`user_comments_${decoded.id}`, data);
        return res.status(200).send(result);
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}