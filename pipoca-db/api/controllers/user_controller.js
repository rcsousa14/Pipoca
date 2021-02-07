const models = require('../models');


exports.index = async (req , res) => {
    try {
        const users = await models.user.findAll({ attributes: { exclude: ['bio','role_id'] }, 
        include: [{
            model: models.role,
            as: 'role',
            where: { role: "regular" },
            attributes: { exclude: ['createdAt','updatedAt','id'] }
        }] });
        
        return res.status(200).send({ message: "here is all the users admin", users });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

exports.show = async ({ decoded }, res) => {
    /** 
     * TODO: this needs to include:
     * the total number of user posts
     * the total number of user comments
     * the total number of user subcomments
     * maybe try to combine them( see the ui first)
     * the total number of votes (post, comments, sub_comments)
    */
    try {
        const user = await models.user.findOne({

            where: {
                id: decoded.id
            },
            include: [{
                model: models.role,
                as: 'role',
                where: { role: "regular" },
                attributes: { exclude: ['createdAt','updatedAt','id'] }
            }] 
        });

        return res.status(200).send({ message: "😁 Usuário foi encontrado", user });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }



};

exports.destroy = async ({ decoded }, res) => {
    try {
         await models.user.destroy({
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
        // figure out how to patch instead
        const {phone_number, phone_carrier, username, avatar, birthday, bio, fcm_token} =body;
        const user = await models.user.update({body}, {
            where: {
                id: decoded.id
            },
            
        });
        
        return res.status(200).send({ message: "🍿 So sucesso! de volta a pipocar 😆", user });
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }

};

