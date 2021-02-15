'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class comment_vote extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      this.belongsTo(models.user,{
        as: 'user_comment_vote',
        foreignKey: 'user_id'
      });
      this.belongsTo(models.comment,{
        as: 'post_comment_vote',
        foreignKey: 'comment_id'
        

      });
    }
  };
  comment_vote.init({
    user_id: DataTypes.INTEGER,
    comment_id: DataTypes.INTEGER,
    voted: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'comment_vote',
  });
  return comment_vote;
};