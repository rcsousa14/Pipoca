const models = require('../models');

exports.store = async({ body, decoded }, res, ) => {
    try {

        const { comment_id, voted } = body;
        const post = await models.comment.findByPk(comment_id);
        if (!post) {
            return res.status(400).send({ message: '🤔 Bago não foi encontrado!' });
        }
        const vote = await models.comment_vote.findOne({
            where: { user_id: decoded.id, comment_id: comment_id }
        });

        if (vote) {
            const updated_vote = await models.comment_vote.update({ id: vote.id, user_id: decoded.id, voted, comment_id }, {

                where: { id: vote.id },
            });

            return res.status(200).send({ message: "updated", updated_vote });
        }
        const add_vote = await models.comment_vote.create({ user_id: decoded.id, comment_id, voted });
        return res.status(201).send({ message: 'added', add_vote });


    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}