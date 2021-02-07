const models = require('../models');


exports.store = async ({ body }, res) => {
    try {
        
         const { role } = body;
        
        const newRole = await models.role.create({ role });
        return res.status(201).send({ message: "role added!", newRole });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

exports.destroy = async ({ params }, res) => {
    try {
        const { id } = params;
        
        await models.role.destroy({ where: { id: id } });
        return res.status(200).send({ message: `role with id:${id} was deleted!` });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

exports.index = async (req, res) => {
    try {
       
        const roles = await models.role.findAll();

        return res.status(200).json({ message: "here is all the roles!", roles });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}