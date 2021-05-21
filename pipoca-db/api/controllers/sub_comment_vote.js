import ApiError from "../errors/api_error";

const models = require("../models");

exports.store = async({ body, decoded }, res, next) => {
    try {
        const { id, voted } = body;

        const post = await models.sub_comment.findByPk(id);
        if (!post) {
            next(ApiError.badRequestException("Bago não foi encontrado!"));
            return;
        }

        const vote = await models.sub_comment_vote.findOne({
            where: { user_id: decoded.id, sub_comment_id: id },
        });

        if (vote) {
            await models.sub_comment_vote.update({ id: vote.id, user_id: decoded.id, voted, sub_comment_id: id }, {
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