const Sequelize  = require('sequelize');
const models = require('../models');




exports.index = async({ body, decoded }, res) => {
    try {
        /**
         * TODO: this is the index to see all the posts update the isnear to enable commenting 
         * figure out how to work with geometry in sequelize
         * return a status with point and excluded the coordinates of other users this is important
         * need to put limits and sort it
         */
        
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};
exports.show = async({ params }, res) => {
    try {
        const { id } = params;
        var post = await models.post.findOne({
            where: {id: id},
            include: [
                {
                    model: models.user, 
                    as: 'user',
                    attributes: {exclude: ['createdAt','updatedAt','phone_number', 'phone_carrier', 'birthday','role_id']}
                }]

        });
        return res.status(200).send({ message: `🍿 Bago ${id}  para ti 🥳`, post });
        
       
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};



