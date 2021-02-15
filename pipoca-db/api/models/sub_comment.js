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
        foreignKey: 'user_id'
      });
      this.belongsTo(models.comment,{
        as: 'comment_sub_comment',
        foreignKey: 'comment_id'
      });
      this.hasMany(models.sub_comment_vote, {
        as: 'sub_comment_votes',
        foreignKey: 'sub_comment_id'
      });
      
    }
  };
  sub_comment.init({
    user_id: DataTypes.INTEGER,
    comment_id: DataTypes.INTEGER,
    content: DataTypes.STRING(200),
    links: DataTypes.ARRAY(DataTypes.STRING),
    flags: DataTypes.INTEGER,
    reply_to: DataTypes.STRING(50),
    reply_to_fcm_token:  DataTypes.STRING,
    is_flagged: DataTypes.BOOLEAN,
    coordinates: DataTypes.GEOMETRY('POINT'),
    is_deleted: DataTypes.BOOLEAN
  }, {
    sequelize,
    modelName: 'sub_comment',
  });
  return sub_comment;
};