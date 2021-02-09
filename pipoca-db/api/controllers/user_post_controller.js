const models = require('../models');
const Sequelize = require('sequelize');
const { post } = require('got');

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

exports.index = async ({ body, query, decoded }, res) => {
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
        const page = parseInt(query.page);
        const limit = parseInt(query.limit);
        const startIndex = (page - 1) * limit;
        const endIndex = page * limit;
        var oldPosts = await models.post.findAll({
            
            order: [
                ['createdAt', 'DESC']
            ],
            group: ['post.id', 'creator.id', ],

            where: Sequelize.where(
                Sequelize.fn('ST_DWithin',
                    Sequelize.col('coordinates'),
                    Sequelize.fn('ST_SetSRID',
                        Sequelize.fn('ST_MakePoint',
                            lng, lat),
                        4326),
                    0.032),
                true),
            attributes: [
                'id',
                'content',
                'links',
                'tags',
                'flags',
                'is_flagged',
                'createdAt',

                [Sequelize.cast(Sequelize.fn('COUNT', Sequelize.col('post_comments.id')),'INT'), 'post_comments_total'],
                [Sequelize.cast(Sequelize.fn('SUM', Sequelize.col('post_votes.voted')),'INT'), 'posts_votes_total'],
            ],
            include: [
                {
                    model: models.user,
                    as: 'creator',
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
            ],

        });
        var newPost = [];
        for (var post of oldPosts) {

            

            const votes = await models.post_vote.findOne({
                where: { user_id: decoded.id, post_id: post.id },
                attributes: { exclude: ['user_id', 'post_id', 'createdAt', 'updatedAt', 'id'] }
            });
            const isVoted = votes ? true : false;
            


            newPost.push({
                "user_voted": isVoted,
                "user_vote": votes,
                post
            });

        };

        const posts = {};
        posts.total = {
           data_total: newPost.length
        }
        if(endIndex < newPost.length){
            posts.next = {
                page: page + 1,
                limit: limit
            }
        }
       
        if(startIndex > 0){
            posts.previous = {
                page: page - 1,
                limit: limit
            }
    
        }
        
        posts.data = newPost.slice(startIndex, endIndex);



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

exports.show = async ({ query, decoded }, res) => {
    try {
        const page = parseInt(query.page);
        const limit = parseInt(query.limit);
        const startIndex = (page - 1) * limit;
        const endIndex = page * limit;
        const oldPosts = await models.post.findAll({
            group: ['post.id', 'creator.id'],
            order: [
                ['createdAt', 'DESC']
            ],
            where: { user_id: decoded.id },
            attributes: [
                'id',
                'content',
                'links',
                'tags',
                'flags',
                'is_flagged',
                'createdAt',
                [Sequelize.cast(Sequelize.fn('COUNT', Sequelize.col('post_comments.id')),'INT'), 'post_comments_total'],
                [Sequelize.cast(Sequelize.fn('SUM', Sequelize.col('post_votes.voted')),'INT'), 'posts_votes_total'],
            ],
            include: [
                {
                    model: models.user,
                    as: 'creator',
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
        var newPost = [];
        for (var post of oldPosts) {

            

            const votes = await models.post_vote.findOne({
                where: { user_id: decoded.id, post_id: post.id },
                attributes: { exclude: ['user_id', 'post_id', 'createdAt', 'updatedAt', 'id'] }
            });
            const isVoted = votes ? true : false;
            


            newPost.push({
                "user_voted": isVoted,
                "user_vote": votes,
                post
            });

        };
        
       
           const items_total = newPost.length
           var page_info = {
            
           }
      
        if(endIndex < newPost.length){
           
                page_info.next = {
                    next_page: page + 1,
                    page_limit: limit
                }
           
        }
       
        if(startIndex > 0){
            page_info.previous = {
                previous_page: page - 1,
                page_limit: limit
            }
    
        }
        
        var data = newPost.slice(startIndex, endIndex);

        return res.status(200).send({ message: `Aqui esta todos os teu Bagos! 🍿`, items_total, page_info, data });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}