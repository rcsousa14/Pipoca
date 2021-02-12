const models = require('../models');
const Sequelize = require('sequelize');
const { paginate } = require('../utils/paginate');

exports.store = async({ params, body, decoded }, res) => {
    try {
        const { post_id } = params;
        const { content, links, tags } = body;

        await models.comment.create({ user_id: decoded.id, post_id, content, links, tags, flags: 0, })

        return res.status(201).send({ message: '🍿 Commentario criado com sucesso! 🥳' })
    } catch (error) {
        return res.status(500).json({
            error: error.message
        })
    }
}

exports.index = async({ params, query, decoded }, res) => {
    try {
        const vote = 'comment';
        const { post_id } = params;
        const { filter } = query;
        const id = decoded.id;
        const page = parseInt(query.page);
        const limit = 12;
        let search = { post_id: post_id };

        let order = [];
        let group = ['comment.id', 'creator.id'];
        if (filter == 'date') {
            order.push(
                ['createdAt', 'DESC']
            )
        }
        if (filter == 'pipocar') {
            // order.push(
            //     [Sequelize.literal('votes_total ASC')],
            //     [Sequelize.literal('sub_comments_total ASC')]
            // )
        }
        let attributes = [
            'id',
            'content',
            'links',
            'tags',
            'flags',
            'is_flagged',
            'createdAt',
            //[Sequelize.cast(Sequelize.fn('COUNT', Sequelize.col('comment_sub_comments.id')), 'INT'), 'sub_comments_total'],
            //[Sequelize.cast(Sequelize.fn('SUM', Sequelize.col('comment_votes.voted')), 'INT'), 'votes_total'],
        ];
        let include = [{
                model: models.user,
                as: 'creator',
                attributes: { exclude: ['createdAt', 'updatedAt', 'phone_number', 'phone_carrier', 'birthday', 'role_id', 'bio'] }
            },

            // {


            //     model: models.comment_vote,
            //     as: 'comment_votes',
            //     attributes: [],
            //     duplicating: false,
            //     required: false

            // },
            // {
            //     model: models.sub_comment,
            //     as: 'comment_sub_comments',
            //     attributes: [],
            //     duplicating: false,
            //     required: false

            // },
        ];
        const model = models.comment;
        const comments = await paginate(model, id, page, limit, search, order, attributes, include, group, vote);

        return res.status(200).send({ message: '🍿 Todos os Commentarios proximo de ti 🥳', comments });

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
        const vote = 'comment';
        const page = parseInt(query.page);
        const limit = 12;
        const id = decoded.id
        let search = { user_id: decoded.id };
        let order = [
            ['createdAt', 'DESC']
        ];
        let group = ['comment.id', 'creator.id'];
        let attributes = [
            'id',
            'content',
            'links',
            'tags',
            'flags',
            'is_flagged',
            'createdAt',
            //[Sequelize.cast(Sequelize.fn('COUNT', Sequelize.col('comment_sub_comments.id')), 'INT'), 'sub_comments_total'],
            //[Sequelize.cast(Sequelize.fn('SUM', Sequelize.col('comment_votes.voted')), 'INT'), 'votes_total'],
        ];

        let include = [{
                model: models.user,
                as: 'creator',
                attributes: { exclude: ['createdAt', 'updatedAt', 'phone_number', 'phone_carrier', 'birthday', 'role_id', 'bio'] }
            },

            // {


            //     model: models.comment_vote,
            //     as: 'comment_votes',
            //     attributes: [],
            //     duplicating: false,
            //     required: false

            // },
            // {
            //     model: models.sub_comment,
            //     as: 'comment_sub_comments',
            //     attributes: [],
            //     duplicating: false,
            //     required: false

            // },
        ];
        const model = models.comment;
        const comments = await paginate(model, id, page, limit, search, order, attributes, include, group, vote);

        return res.status(200).send({ message: '🍿 Todos os teus Commentarios  🥳', comments });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}