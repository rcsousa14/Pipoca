const models = require('../models');
const Sequelize = require('sequelize');
const { paginate } = require('../utils/paginate');

exports.store = async({ params, body, decoded }, res) => {
    try {
        const { comment_id } = params;
        const { content, links, tags } = body;

        await models.sub_comment.create({ user_id: decoded.id, comment_id, content, links, tags, flags: 0, })

        return res.status(201).send({ message: '🍿 Commentario criado com sucesso! 🥳' })
    } catch (error) {
        return res.status(500).json({
            error: error.message
        })
    }
}

exports.index = async({ params, query, decoded }, res) => {
    try {
        const { comment_id } = params;
        const vote = 'sub';
        const id = decoded.id;
        const page = parseInt(query.page);
        const limit = 6;
        let group = ['sub_comment.id', 'creator.id'];
        let search = {
            where: { comment_id: comment_id },
        }
        let order = [];

        order.push(
            // [Sequelize.literal('votes_total ASC')],
            ['createdAt', 'DESC']
        );


        let attributes = [
            'id',
            'content',
            'links',
            'tags',
            'flags',
            'is_flagged',
            'createdAt',

            // [Sequelize.cast(Sequelize.fn('SUM', Sequelize.col('sub_comment_votes.voted')), 'INT'), 'votes_total'],
        ];
        let include = [{
                model: models.user,
                as: 'creator',
                attributes: { exclude: ['createdAt', 'updatedAt', 'phone_number', 'phone_carrier', 'birthday', 'role_id', 'bio'] }
            },

            // {


            //     model: models.sub_comment_vote,
            //     as: 'sub_comment_votes',
            //     attributes: [],
            //     duplicating: false,
            //     required: false

            // },

        ];
        const model = models.sub_comment;
        const sub_comments = await paginate(model, id, page, limit, search, order, attributes, include, group, vote);

        return res.status(200).send({ message: '🍿 Todos os Commentarios proximo de ti 🥳', sub_comments });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        })
    }
}

exports.destroy = async({ params, decoded }, res) => {
    try {
        /**
         * once i figure out soft delete
         * this will probably just be a patch
         */
        const { id } = params
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}

exports.show = async({ query, decoded }, res) => {
    try {

        const page = parseInt(query.page);
        const limit = 12;
        const vote = 'sub';
        let search = { user_id: decoded.id };
        let group = ['sub_comment.id', 'creator.id'];
        let order = [
            ['createdAt', 'DESC']
        ];
        let attributes = [
            'id',
            'content',
            'links',
            'tags',
            'flags',
            'is_flagged',
            'createdAt',

            //[Sequelize.cast(Sequelize.fn('SUM', Sequelize.col('sub_comment_votes.voted')), 'INT'), 'votes_total'],
        ];
        let include = [{
                model: models.user,
                as: 'creator',
                attributes: { exclude: ['createdAt', 'updatedAt', 'phone_number', 'phone_carrier', 'birthday', 'role_id', 'bio'] }
            },

            // {


            //     model: models.sub_comment_vote,
            //     as: 'sub_comment_votes',
            //     attributes: [],
            //     duplicating: false,
            //     required: false

            // },

        ];
        const model = models.sub_comment;
        const sub_comments = await paginate(model, id, page, limit, search, order, attributes, include, group, vote);

        return res.status(200).send({ message: '🍿 Todos os teus Commentarios  🥳', sub_comments });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}