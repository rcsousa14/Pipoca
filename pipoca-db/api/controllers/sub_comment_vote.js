const models = require("../models");
const ApiError = require("../errors/api_error");

exports.store = async({ body, decoded }, res) => {
    try {
        const { subCommentId, voted } = body;
        const post = await models.sub_comment.findByPk(subCommentId);
        if (!post) {
            return res.status(400).json({ message: "🤔 Bago não foi encontrado!" });
        }
        const vote = await models.sub_comment_vote.findOne({
            where: { userId: decoded.id, sub_comment_id: subCommentId },
        });

        if (vote) {
            await models.sub_comment_vote.update({ userId: decoded.id, voted, sub_comment_id: subCommentId }, {
                where: { id: vote.id },
            });
            cache.del(`user_sub_comments_feed_${decoded.id}`);
            cache.del(`user_sub_comments_${decoded.id}`);
            return res.status(200).json({
                success: true,
                message: "updated",
            });
        }
        await models.sub_comment_vote.create({
            userId: decoded.id,
            sub_comment_id: subCommentId,
            voted,
        });
        cache.del(`user_sub_comments_feed_${decoded.id}`);
        cache.del(`user_sub_comments_${decoded.id}`);
        return res.status(201).json({
            success: true,
            message: "added",
        });
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};