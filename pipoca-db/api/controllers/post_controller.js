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
            group: ['post.id','user_post.id', 'post_comments.id', 'post_votes.id'],
            where: {id: id},
            attributes: [
                'id',
                'content',
                'links',
                'tags',
                'flags',
                'is_flagged',
                'createdAt',
                [Sequelize.fn('COUNT', Sequelize.col('post_comments.id')), 'post_comments_total'],
                [Sequelize.fn('SUM', Sequelize.col('post_votes.voted')), 'posts_votes_total'],
            ],
            include: [
                {
                    model: models.user,
                    as: 'user_post',
                    attributes: { exclude: ['createdAt', 'updatedAt', 'phone_number', 'phone_carrier', 'birthday', 'role_id'] }
                },
                {


                    model: models.post_vote,
                    as: 'post_votes',
                    attributes: [],


                },
                {
                    model: models.comment,
                    as: 'post_comments',
                    attributes: [],


                },
            ]

        });
        return res.status(200).send({ message: `🍿 Bago ${id}  para ti 🥳`, post });
        
       
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};



