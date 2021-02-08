const models = require('../models');

exports.store = async({body, decoded}, res, ) => {
    try {
        
        const { post_id, voted } = body;
        const post = await models.post.findByPk(post_id);
        if(!post){
            return res.status(400).send({ message: '🤔 Bago não foi encontrado!'});
        }
        const vote = await models.post_vote.findOne({
            where: {user_id: decoded.id, post_id: post_id}
        });
        
        if(vote){
            const updated_vote = await models.post_vote.update({id: vote.id, user_id: decoded.id, voted, post_id}, {
                
                 where: { id: vote.id },
            });
            
            return res.status(200).send({message: "updated", updated_vote });
        }
        const add_vote = await models.post_vote.create({user_id: decoded.id, post_id, voted});
            return res.status(201).send({message:'added', add_vote});
        

    }catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}
