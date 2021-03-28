'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class sub_comment extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      this.belongsTo(models.user,{
        as: 'creator',
        foreignKey: 'userId'
      });
      this.belongsTo(models.user,{
        as: 'replyTo',
        foreignKey: 'userId'
      });
      this.belongsTo(models.comment,{
        as: 'comment_sub_comment',
        foreignKey: 'commentId'
      });
      this.hasMany(models.sub_comment_vote, {
        as: 'sub_comment_votes',
        foreignKey: 'subCommentId'
      });
      
    }
  };
  sub_comment.init({
    userId: DataTypes.INTEGER,
    commentId: DataTypes.INTEGER,
    content: DataTypes.STRING(200),
    flags: DataTypes.INTEGER,
    replyToId: DataTypes.INTEGER,
    isFlagged: DataTypes.BOOLEAN,
    coordinates: DataTypes.GEOMETRY('POINT'),
    isDeleted: DataTypes.BOOLEAN
  }, {
    sequelize,
    modelName: 'sub_comment',
  });
  return sub_comment;
};