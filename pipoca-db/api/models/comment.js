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
        foreignKey: 'user_id'
      });
      comment.belongsTo(models.post,{
        as: 'post_comment',
        foreignKey: 'post_id'
      });
      comment.hasMany(models.comment_vote, {
        as: 'comment_votes',
        foreignKey: 'comment_id'
      });
      comment.hasMany(models.sub_comment, {
        as: 'comment_sub_comments',
        foreignKey: 'comment_id'
      })
    }
  };
  comment.init({
    user_id: DataTypes.INTEGER,
    post_id: DataTypes.INTEGER,
    content: DataTypes.STRING(200),
    links: DataTypes.ARRAY(DataTypes.STRING),
    flags: DataTypes.INTEGER,
    is_flagged: DataTypes.BOOLEAN,
    coordinates: DataTypes.GEOMETRY('POINT'),
    is_deleted: DataTypes.BOOLEAN
  }, {
    sequelize,
    modelName: 'comment',
  });
  return comment;
};