const models = require("../models");
const ApiError = require("../errors/api_error");

exports.store = async({ body, decoded }, res, next) => {
    try {
        const { id, voted } = body;
        const post = await models.sub_comment.findByPk(id);
        if (!post) {
            return res.status(400).json({ message: "🤔 Bago não foi encontrado!" });
        }
        const vote = await models.sub_comment_vote.findOne({
            where: { user_id: decoded.id, sub_comment_id: id },
        });

        if (vote) {
            await models.sub_comment_vote.update({ user_id: decoded.id, voted, sub_comment_id: id }, {
                where: { id: vote.id },
            });

            return res.status(200).json({
                success: true,
                message: "updated",
            });
        }
        await models.sub_comment_vote.create({
            user_id: decoded.id,
            sub_comment_id: id,
            voted,
        });

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