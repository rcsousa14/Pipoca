const Sequelize  = require('sequelize');
const models = require('../models');


exports.store = async({body, decoded}, res) => {
    try {
        const {content, links, tags, longitude, latitude} = body;

        var point = { 
            type: 'Point', 
            coordinates: [longitude, latitude],
            
        };

        await models.post.create({user_id: decoded.id, content, links, tags, flags: 0, coordinates: point})
        
        return res.status(201).send({ message: '🍿 Bago criado com sucesso! 🥳'});

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

exports.index = async({ query }, res) => {
    try {
        /**
         * TODO: this is the index to see all the post that are nearby (user perspective)
         * 
         * 
         * in the includes i need to add the karma total and post total
         * find it withing 4.5km
         * query is like this ?lat=0&lng=0
         */
        const { lat, lng } = query;
        var posts = await models.post.findAll({
            where: Sequelize.where(
                Sequelize.fn('ST_DWithin', 
                    Sequelize.col('coordinates'),
                    Sequelize.fn('ST_SetSRID',
                    Sequelize.fn('ST_MakePoint', 
                    lng, lat),
                    4326),
                    0.032),
                 true),
                attributes: {exclude: ['coordinates','user_id']},
                include: [
                    {
                        model: models.user, 
                        as: 'user_post',
                        attributes: {exclude: ['createdAt','updatedAt','phone_number', 'phone_carrier', 'birthday','role_id']}
                    }
                    ]
        });

        return res.status(200).send({ message: '🍿 Todos os Bagos proximo de ti 🥳', posts });
        
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

exports.destroy = async({ params, decoded }, res) => {
    try {
        const { id } = params; 
        /**
         * TODO: check if there is find and destroy
         */
        await models.post.destroy({
            where: {
                id: id,
                user_id: decoded.id
            }
        });
        return res.status(200).send({message: `Bago ${id} foi eliminado com sucesso`});
    } catch (error) {
        return res.status(500).json({
            error: error.message
        }); 
    }
}