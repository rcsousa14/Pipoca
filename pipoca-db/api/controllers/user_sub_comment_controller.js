import CacheService from '../utils/cache';
const models = require('../models');
const Sequelize = require('sequelize');
const { paginate } = require('../utils/paginate');
const ttl = 10;
const cache = new CacheService(ttl);
const cachePost = new CacheService(60);

exports.store = async ({ params, body, decoded }, res) => {
    try {
        const { commentId } = params;
        const { content, links, hashes, reply_to_id,  longitude, latitude } = body;

        const result = cachePost.get(`user_sub_comment_${decoded.id}`);
        if (result && result == content) {
            
            return res.status(550).json({ message: '🖐🏾 Eh mano ninguem gosta de spam 👾' });
        }
        var point = {
            type: 'Point',
            coordinates: [longitude, latitude],
            crs: { type: 'name', properties: { name: 'EPSG:4326' } }

        };

        const sub_comment = await models.sub_comment.create({ userId: decoded.id, reply_to_id, comment_id: commentId, content,  coordinates: point });

        if (hashes) {
            for (var hash of hashes) {
                const [tag] = await models.tag.findOrCreate({
                    where: { hash: hash }
                });

                await models.post_tag.create({sub_comment_id: sub_comment.id, tag_id: tag.id});
            }
        }
        if (links) {

            getLinkData({ url: links[0] });
            const link = await models.link.findOne({where: {url: links[0]}})
  
            await models.post_link.create({sub_comment_id: sub_comment.id,  link_id: link.id});
           
               
           }

        cachePost.set(`user_sub_comment_${decoded.id}`, sub_comment.content);
        cache.del(`user_sub_comments_feed_${decoded.id}`);
        cache.del(`user_sub_comments_${decoded.id}`);
        return res.status(201).send({ message: '🍿 sub commentario criado com sucesso! 🥳' });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        })
    }
}

exports.index = async ({ params, query, decoded }, res) => {
    try {
        const result = cache.get(`user_sub_comments_feed_${decoded.id}`);
        if (result) {
            return res.status(200).json(result);
        }
        const filtro = 'sub';
        const { commentId } = params;
        const { lat, lng } = query;
        const id = decoded.id;
        const page = parseInt(query.page);
        const limit = 4;
        let group = ['sub_comment.id', 'creator.id'];
        let search = {
            where: { comment_id: commentId },
        }
        let order = [];

        order.push(
            [Sequelize.literal('votesTotal ASC')],

        );


        let attributes = [
            'id',
            'content',
            'flags',
            'is_flagged',
            'createdAt',
            'coordinates', [Sequelize.literal(`(SELECT CAST(SUM(voted) AS INT)  fROM sub_comment_votes WHERE sub_comment_id = sub_comment.id)`), 'votes_total'],
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
        const model = models.sub_comment;
        const sub_comments = await paginate(model, id, page, limit, search, order, attributes, include, group, lat, lng, filtro);
        const data = { message: '🍿 Todos os sub commentarios proximo de ti 🥳', sub_comments };
        cache.set(`user_sub_comments_feed_${decoded.id}`, data);
        return res.status(200).send(data);

    } catch (error) {
        return res.status(500).json({
            error: error.message
        })
    }
}

exports.soft = async ({ params, decoded }, res) => {
    try {

        await models.sub_comment.update({
            isDeleted: true
        }, {
            where: {
                userId: decoded.id,
                id: params.id
            }
        });
        cache.del(`user_sub_comments_feed_${decoded.id}`);
        cache.del(`user_sub_comments_${decoded.id}`);
        return res.status(200).send({ message: `Bago ${params.id} foi eliminado com sucesso` })
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}

exports.show = async ({ query, decoded }, res) => {
    try {
        const result = cache.get(`user_sub_comments_${decoded.id}`);
        if (result) {
            return res.status(200).json(result);
        }
        const filtro = 'sub';
        const page = parseInt(query.page);
        const { lat, lng } = query;
        const limit = 9;
        const id = decoded.id;
        let search = { user_id: id };
        let group = ['sub_comment.id', 'creator.id'];
        let order = [
            ['createdAt', 'DESC']
        ];
        let attributes = [
            'id',
            'content',
            'flags',
            'is_deleted',
            'createdAt',
            'coordinates',

            [Sequelize.literal(`(SELECT CAST(SUM(voted) AS INT)  fROM sub_comment_votes WHERE sub_comment_id = sub_comment.id)`), 'votes_total'],
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
        const model = models.sub_comment;
        const sub_comments = await paginate(model, id, page, limit, search, order, attributes, include, group, lat, lng, filtro);
        const data = { message: '🍿 Todos os teus sub commentarios  🥳', sub_comments };
        cache.set(`user_sub_comments_${decoded.id}`, data);
        return res.status(200).send(data);
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}