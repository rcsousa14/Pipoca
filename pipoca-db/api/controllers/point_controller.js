const models = require('../models');

exports.store = async({body, decoded}, res, next) => {
    try {
        const { isPoint, post_id } = body; 
        
        const post = await models.post.findByPk(post_id);
        if(!post){
            return res.status(400).send({ message: '🤔 Bago não foi encontrado'});
        }
        const [point, created ] = await models.point.findOrCreate({
            where: {user_id: decoded.id, isPoint}
        });
        if(!created){
            await post.addpoint(point);
            return res.status(201).json( point );
        }
        await post.setpoint(point);
        //figure out the code for update
        return res.status(201).json( point );

    }catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}