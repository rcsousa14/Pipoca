const { paginate } = require('../utils/paginate');
const models = require('../models');
const Sequelize = require('sequelize');

const Op = Sequelize.Op;

exports.store = async ({ body, decoded }, res) => {
    try {
        const { content, links, hashes, longitude, latitude } = body;

        var point = {
            type: 'Point',
            coordinates: [longitude, latitude],

        };

        const post = await models.post.create({ user_id: decoded.id, content, links, coordinates: point });
        if (hashes) {
            for (var hash of hashes) {
                const [ tag ] = await models.tag.findOrCreate({
                    where: { hash: hash }
                });
                
                await post.addTag(tag);
            }

        }


        return res.status(201).send({ message: '🍿 Bago criado com sucesso! 🥳' });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};
//feed shows all posts that are near by you can sort it for posts with higher points
exports.index = async ({ query, decoded }, res) => {
    try {
        const vote = 'post';
        const { lat, lng } = query;
        const id = decoded.id;
        const page = parseInt(query.page);
        const limit = 9;

        let search;
        let order = [];
        const TODAY_START = new Date().setHours(0, 0, 0, 0); 
        const NOW = new Date();
        if (lat && lng) {
            if(query.filter == 'pipocar'){
                search = { 
                    [Op.gt]: TODAY_START,
                    [Op.lt]: NOW,
                    $and:Sequelize.where(
                    Sequelize.fn('ST_DWithin',
                        Sequelize.col('coordinates'),
                        Sequelize.fn('ST_SetSRID',
                            Sequelize.fn('ST_MakePoint',
                                lng, lat),
                            4326),
                        950),
                    true)
                }
            }
            search = {
                is_deleted: false,
                $and: Sequelize.where(
                Sequelize.fn('ST_DWithin',
                    Sequelize.col('coordinates'),
                    Sequelize.fn('ST_SetSRID',
                        Sequelize.fn('ST_MakePoint',
                            lng, lat),
                        4326),
                    950),
                true)
            }
        }
        let group = ['post.id', 'creator.id'];
        if (query.filter == 'pipocar') {
            
            order.push(
                [Sequelize.literal('votes_total DESC')]
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
            [Sequelize.cast(Sequelize.fn('SUM', Sequelize.col('post_votes.voted')), 'INT'), 'votes_total'],
        ];

        let include = [
            {
                model: models.user,
                as: 'creator',
                attributes: { exclude: ['createdAt', 'updatedAt', 'phone_number', 'phone_carrier', 'birthday', 'role_id', 'bio'] }
            },
            {
                model: models.post_vote,
                as: 'post_votes',
                attributes: [],
                duplicating: false,
                required: false

            },

        ];
        const model = models.post;
        const posts = await paginate(model, id, page, limit, search, order, attributes, include, group, vote, lat, lng);




        return res.status(200).send({ message: '🍿 Todos os Bagos proximo de ti 🥳', posts });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};
// deletes users posts
exports.soft = async ({ params, decoded }, res) => {
    try {
        const { id } = params;
        await models.post.update({
            is_deleted: false
        },{
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
// shows all posts by user
exports.show = async ({ query, decoded }, res) => {
    try {
        const vote = 'post';
        const { lat, lng } = query;
        const id = decoded.id;
        const page = parseInt(query.page);
        const limit = 9;

        let search = { user_id: decoded.id, is_deleted: false };
        let order = [
            ['createdAt', 'DESC']
        ];
        let group = ['post.id', 'creator.id'];
        let attributes = [
            'id',
            'content',
            'links',
            'flags',
            'is_flagged',
            'is_deleted',
            'createdAt',
            'coordinates',
            [Sequelize.cast(Sequelize.fn('SUM', Sequelize.col('post_votes.voted')), 'INT'), 'votes_total'],
        ];

        let include = [
            {
                model: models.user,

                as: 'creator',
                attributes: { exclude: ['createdAt', 'updatedAt', 'phone_number', 'phone_carrier', 'birthday', 'role_id', 'bio'] }
            },

            {
                model: models.post_vote,
                as: 'post_votes',
                attributes: [],
                duplicating: false,
                required: false

            },
            
        ];
        const model = models.post;
        const posts = await paginate(model, id, page, limit, search, order, attributes, include, group, vote, lat, lng);


        return res.status(200).send({ message: `Aqui esta todos os teu Bagos! 🍿`, posts });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}