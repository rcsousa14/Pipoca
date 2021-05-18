const ApiError = require("../errors/api_error");
const models = require("../models");

exports.store = async({ body, decoded }, res, next) => {
    try {

        const { id, voted } = body;
        const post = await models.post.findByPk(id);
        if (!post) {
            next(ApiError.badRequestException("Bago não foi encontrado!"));
            return;
        }
        const vote = await models.post_vote.findOne({
            where: { user_id: decoded.id, post_id: id },
        });

        if (vote) {
            await models.post_vote.update({ user_id: decoded.id, voted, post_id: id }, {
                where: { id: vote.id },
            });

            return res.status(200).send({
                success: true,
                message: "updated",
            });
        } else {
            await models.post_vote.create({ user_id: decoded.id, post_id: id, voted });

            return res.status(201).send({
                success: true,
                message: "added",
            });
        }
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};