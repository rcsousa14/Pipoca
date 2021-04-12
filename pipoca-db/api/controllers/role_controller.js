const models = require("../models");
const ApiError = require("../errors/api_error");

exports.store = async({ body }, res) => {
    try {
        const { role } = body;

        await models.role.create({ role });
        return res.status(201).json({ success: true, message: "role added!" });
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};

exports.destroy = async({ params }, res) => {
    try {
        const { id } = params;

        await models.role.destroy({ where: { id: id } });
        return res
            .status(200)
            .json({ success: true, message: `role with id:${id} was deleted!` });
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};

exports.index = async(req, res) => {
    try {
        const roles = await models.role.findAll();

        return res
            .status(200)
            .json({ success: true, message: "here is all the roles!", roles });
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};