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
                foreignKey: 'roleId'
            });
            user.hasMany(models.post, {
                as: 'posts',
                foreignKey: 'userId'
            });
            user.hasMany(models.post_vote, {
                as: 'post_votes',
                foreignKey: 'userId'
            });
            user.hasMany(models.comment_vote, {
                as: 'comment_votes',
                foreignKey: 'userId'
            });
            user.hasMany(models.comment, {
                as: 'comments',
                foreignKey: 'userId'
            });
            user.hasMany(models.sub_comment, {
                as: 'sub_comments',
                foreignKey: 'userId'
            });
            user.hasMany(models.sub_comment, {
                as: 'sub_comment_replys',
                foreignKey: 'replyToId'
            });
            user.hasMany(models.sub_comment_vote, {
                as: 'sub_comment_votes',
                foreignKey: 'userId'
            })
        }
    };
    user.init({
        refreshToken: DataTypes.STRING,
        email: DataTypes.STRING,
        password: DataTypes.STRING(64),
        resetPasswordToken: DataTypes.STRING,
        resetPasswordExpiration: DataTypes.DATE,
        roleId: DataTypes.INTEGER,
        username: DataTypes.STRING(20),
        avatar: DataTypes.STRING,
        birthday: DataTypes.STRING(15),
        bio: DataTypes.STRING(124),
        fcmToken: DataTypes.STRING,
        type: DataTypes.STRING(20),
        active: DataTypes.BOOLEAN
    }, {
        sequelize,
        modelName: 'user',
    });
    return user;
};