const models = require('../models');

exports.store = async({ body, decoded }, res) => {
    try {
        const { id } = decoded;
        const { postId, voted } = body;
        const post = await models.post.findByPk(postId);
        if (!post) {
            return res.status(400).send({ message: '🤔 Bago não foi encontrado!' });
        }
        const vote = await models.post_vote.findOne({
            where: { user_id: id, post_id: postId }
        });

        if (vote) {
            const updated_vote = await models.post_vote.update({ userId: id, voted, post_id: postId }, {

                where: { id: vote.id },
            });
            cache.del(`post_${id}`);


            return res.status(200).send({ message: "updated", updated_vote });
        }
        const add_vote = await models.post_vote.create({ userId: id, post_id: postId, voted });
        cache.del(`post_${id}`);


        return res.status(201).send({ message: 'added', add_vote });


    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}