const models = require('../models');


exports.store = async ({ body, decoded }, res) => {
    try {
        //TODO: learn how to do includes 
         const { role } = body;
        const {id} = await models.role.findOne({where: {role: 'admin'}});
        const admin = await models.user.findOne({ where: { id: decoded.id, role_id: id } });
        if (!admin) {
            return res.status(401).send('401: Unauthorized 💩!');
        }
        const newRole = await models.role.create({ role });
        return res.status(201).send({ message: "role added!", newRole });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

exports.destroy = async ({ params, decoded }, res) => {
    try {
        const { id } = params;
        const role_id = await models.role.findOne({where: {role: 'admin'}});
        const admin = await models.user.findOne({ where: { id: decoded.id, role_id: role_id.id } });
        if (!admin) {
            return res.status(401).send('401: Unauthorized 💩!');
        }
        await models.role.destroy({ where: { id: id } });
        return res.status(200).send({ message: `role with id:${id} was deleted!` });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

exports.index = async ({ decoded }, res) => {
    try {
        const {id} = await models.role.findOne({where: {role: 'admin'}});
        const admin = await models.user.findOne({ where: { id: decoded.id, role_id: id } });
        if (!admin) {
            return res.status(401).send('401: Unauthorized 💩!');
        }
        const roles = await models.role.findAll();

        return res.status(200).json({ message: "here is all the roles!", roles });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}