import ApiError from "../errors/api_error";
import CacheService from "../utils/cache";
const models = require("../models");
const ttl = 10;
const cache = new CacheService(ttl);
exports.store = async({ body, decoded }, res) => {
    try {
        const { commentId, voted } = body;
        const post = await models.comment.findByPk(commentId);
        if (!post) {
            next(ApiError.badRequestException("Bago não foi encontrado!"));
            return;
        }
        const vote = await models.comment_vote.findOne({
            where: { user_id: decoded.id, comment_id: commentId },
        });

        if (vote) {
            await models.comment_vote.update({ id: vote.id, user_id: decoded.id, voted, comment_id: commentId }, {
                where: { id: vote.id },
            });
            cache.del(`user_comments_feed_${decoded.id}`);
            cache.del(`user_comments_${decoded.id}`);
            return res.status(200).send({
                success: true,
                message: "updated",
            });
        }
        await models.comment_vote.create({
            userId: decoded.id,
            comment_id: commentId,
            voted,
        });
        cache.del(`user_comments_feed_${decoded.id}`);
        cache.del(`user_comments_${decoded.id}`);
        return res.status(201).send({
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