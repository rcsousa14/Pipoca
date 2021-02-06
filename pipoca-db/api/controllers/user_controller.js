const models = require('../models');





exports.index = async ({ decoded }, res) => {
    try {
        //TODO: need to figure out where the role equals the name not the id
        const admin = await models.user.findone({ where: { id: decoded.id, role_id: 4 },  });
        if (!admin) {
            return res.status(401).send('401: Unauthorized 💩!');
        }
        const users = await models.user.findAll({attributes: {exclude: ['password']},});
        const { id } = users;
        return res.status(200).send({ message: "here is all the users admin", users    });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

exports.show = async ({ decoded }, res) => {
    try {
        const user = await models.user.findOne({
            
            where: {
                id: decoded.id
            },
            attributes: {exclude: ['password']}
        });
        
        return res.status(200).send({ message: "😁 Usuário foi encontrado", user });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }



};

exports.delete = async ({ decoded }, res) => {
    try {
        const user = await models.user.destroy({
            where: {
                id: decoded.id
            }
        });
        return res.status(200).send({ message: "😞 Nós odiamos ver você ir. Volto logo! 🍿" });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }

};

exports.update = async ({ body, decoded }, res) => {
    try {
        const user = await models.user.update( body, {
            where: {
                id: decoded.id
            },
            attributes: {exclude: ['password']},
        });
        const { id } = user;
        return res.status(200).send({ message: "🍿 So sucesso! de volta a pipocar 😆", user });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }

};

