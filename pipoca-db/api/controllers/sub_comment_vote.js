const models = require('../models');

exports.store = async({ body, decoded }, res, ) => {
    try {

        const { subCommentId, voted } = body;
        const post = await models.sub_comment.findByPk(subCommentId);
        if (!post) {
            return res.status(400).send({ message: '🤔 Bago não foi encontrado!' });
        }
        const vote = await models.sub_comment_vote.findOne({
            where: { userId: decoded.id, sub_comment_id: subCommentId }
        });

        if (vote) {
            const updated_vote = await models.sub_comment_vote.update({  userId: decoded.id, voted, sub_comment_id: subCommentId }, {

                where: { id: vote.id },
            });
            cache.del(`user_sub_comments_feed_${decoded.id}`);
            cache.del(`user_sub_comments_${decoded.id}`);
            return res.status(200).send({ message: "updated", updated_vote });
        }
        const add_vote = await models.sub_comment_vote.create({ userId: decoded.id, sub_comment_id: subCommentId, voted });
        cache.del(`user_sub_comments_feed_${decoded.id}`);
        cache.del(`user_sub_comments_${decoded.id}`);
        return res.status(201).send({ message: 'added', add_vote });


    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}