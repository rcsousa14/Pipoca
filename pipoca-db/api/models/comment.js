'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class comment extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      comment.belongsTo(models.user,{
        as: 'creator',
        foreignKey: 'userId'
      });
      comment.belongsTo(models.post,{
        as: 'post_comment',
        foreignKey: 'postId'
      });
      comment.hasMany(models.comment_vote, {
        as: 'comment_votes',
        foreignKey: 'commentId',
       
      });
      comment.hasMany(models.sub_comment, {
        as: 'comment_sub_comments',
        foreignKey: 'commentId'
      });
      
    }
  };
  comment.init({
    userId: DataTypes.INTEGER,
    postId: DataTypes.INTEGER,
    content: DataTypes.STRING(200),
    flags: DataTypes.INTEGER,
    isFlagged: DataTypes.BOOLEAN,
    coordinates: DataTypes.GEOMETRY('POINT'),
    isDeleted: DataTypes.BOOLEAN
  }, {
    sequelize,
    modelName: 'comment',
  });
  return comment;
};