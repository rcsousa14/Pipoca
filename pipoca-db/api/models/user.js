'use strict';
const {
    Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
    class user extends Model {
        /**
         * Helper method for defining associations.
         * This method is not a part of Sequelize lifecycle.
         * The `models/index` file will call this method automatically.
         */
        static associate(models) {
            // define association here
            user.belongsTo(models.role, {
                as: 'role',
                foreignKey: 'role_id'
            });
            user.hasMany(models.post, {
                as: 'posts',
                foreignKey: 'user_id'
            });
            user.hasMany(models.post_vote, {
                as: 'post_votes',
                foreignKey: 'user_id'
            });
            user.hasMany(models.comment_vote, {
                as: 'comment_votes',
                foreignKey: 'user_id'
            });
            user.hasMany(models.comment, {
                as: 'comments',
                foreignKey: 'user_id'
            });
            user.hasMany(models.sub_comment, {
                as: 'sub_comments',
                foreignKey: 'user_id'
            });
            user.hasMany(models.sub_comment_vote, {
                as: 'sub_comment_votes',
                foreignKey: 'user_id'
            })
        }
    };
    user.init({
        email: DataTypes.STRING,
        password: DataTypes.STRING(64),
        role_id: DataTypes.INTEGER,
        username: DataTypes.STRING(20),
        avatar: DataTypes.STRING,
        birthday: DataTypes.STRING(15),
        bio: DataTypes.STRING(124),
        fcm_token: DataTypes.STRING,
        type: DataTypes.STRING(20),
    }, {
        sequelize,
        modelName: 'user',
    });
    return user;
};