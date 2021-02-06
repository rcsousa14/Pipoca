const models = require('../models');

exports.store = async({body, decoded}, res) => {
    try {
        const {post_text, links, tags, longitude, latitude} = body;
        var point = { type: 'Point', coordinates: [longitude, latitude]};
        const bago = await models.post.create({user_id: decoded.id, post_text, links, tags, flag: 0, total_points: 0, coordinates: point})
        return res.status(201).send({ message: '🍿 Bago criado com sucesso! 🥳'})
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

exports.index = async({ body, decoded }, res) => {
    try {
        /**
         * TODO: this is the index to see all the post that are nearby (user perspective)
         * figure out how to work with geometry in sequelize
         * return a status with point and excluded the coordinates of other users this is important
         */
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};
exports.all = async({ body, decoded }, res) => {
    try {
        /**
         * TODO: this is the index to see all the posts update the isnear to enable commenting 
         * figure out how to work with geometry in sequelize
         * return a status with point and excluded the coordinates of other users this is important
         */
        
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};
exports.show = async({ params, decoded }, res) => {
    try {
        /**
         * TODO: this shows only one post 
         */
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

exports.destroy = async({ decoded }, res) => {
    try {
        //duh
    } catch (error) {
        return res.status(500).json({
            error: error.message
        }); 
    }
}