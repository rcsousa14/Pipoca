const { paginate } = require('../utils/paginate');
const models = require('../models');
const Sequelize = require('sequelize');



exports.store = async({ body, decoded }, res) => {
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
//feed shows all posts that are near by you can sort it for posts with higher points
exports.index = async({ body, query, decoded }, res) => {
    try {
        const vote = 'post';
        const { lat, lng } = body;
        const id = decoded.id;
        const page = parseInt(query.page);
        const limit = 12;

        let search;
        let order = [];

        if (lat && lng) {
            search = Sequelize.where(
                Sequelize.fn('ST_DWithin',
                    Sequelize.col('coordinates'),
                    Sequelize.fn('ST_SetSRID',
                        Sequelize.fn('ST_MakePoint',
                            lng, lat),
                        4326),
                    0.032),
                true)
        }
        let group = ['post.id', 'creator.id'];
        if (query.filter == 'pipocar') {
            // do a sort function for the last part
            // order.push(
            //     [Sequelize.literal('votes_total ASC')], [Sequelize.literal('comments_total ASC')], ['createdAt', 'DESC']
            // );
        }
        if (query.filter == 'date') {
            order.push(['createdAt', 'DESC']);
        }
        let attributes = [
            'id',
            'content',
            'links',
            'tags',
            'flags',
            'is_flagged',
            'createdAt',

            // [Sequelize.cast(Sequelize.fn('COUNT', Sequelize.col('post_comments.id')), 'INT'), 'comments_total'],
            // [Sequelize.cast(Sequelize.fn('SUM', Sequelize.col('post_votes.voted')), 'INT'), 'votes_total'],
        ];

        let include = [{
                model: models.user,
                as: 'creator',
                attributes: { exclude: ['createdAt', 'updatedAt', 'phone_number', 'phone_carrier', 'birthday', 'role_id', 'bio'] }
            },

            // {


            //     model: models.post_vote,
            //     as: 'post_votes',
            //     attributes: [],
            //     duplicating: false,
            //     required: false

            // },
            // {
            //     model: models.comment,
            //     as: 'post_comments',
            //     attributes: [],
            //     duplicating: false,
            //     required: false

            // },
        ];
        const model = models.post;
        const posts = await paginate(model, id, page, limit, search, order, attributes, include, group, vote);




        return res.status(200).send({ message: '🍿 Todos os Bagos proximo de ti 🥳', posts });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};
// deletes users posts
exports.destroy = async({ params, decoded }, res) => {
        try {
            const { id } = params;

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
    // shows all posts by user
exports.show = async({ query, decoded }, res) => {
    try {
        const vote = 'post';
        const id = decoded.id;
        const page = parseInt(query.page);
        const limit = 12;

        let search = { user_id: decoded.id };
        let order = [
            ['createdAt', 'DESC']
        ];
        let group = ['post.id', 'creator.id'];
        let attributes = [
            'id',
            'content',
            'links',
            'tags',
            'flags',
            'is_flagged',
            'createdAt',

            // [Sequelize.cast(Sequelize.fn('COUNT', Sequelize.col('post_comments.id')), 'INT'), 'comments_total'],
            // [Sequelize.cast(Sequelize.fn('SUM', Sequelize.col('post_votes.voted')), 'INT'), 'votes_total'],
        ];

        let include = [{
                model: models.user,

                as: 'creator',
                attributes: { exclude: ['createdAt', 'updatedAt', 'phone_number', 'phone_carrier', 'birthday', 'role_id', 'bio'] }
            },

            // {


            //     model: models.post_vote,
            //     as: 'post_votes',
            //     separate: true,
            //     attributes: [],
            //     duplicating: false,
            //     required: false

            // },
            // {
            //     model: models.comment,
            //     as: 'post_comments',
            //     separate: true,
            //     attributes: [],
            //     duplicating: true,
            //     required: false


            // },
        ];
        const model = models.post;
        const posts = await paginate(model, id, page, limit, search, order, attributes, include, group, vote);


        return res.status(200).send({ message: `Aqui esta todos os teu Bagos! 🍿`, posts });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}