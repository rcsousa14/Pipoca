'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class sub_comment_vote extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      this.belongsTo(models.user, {
        as:'user_sub_comment_vote',
        foreignKey: 'user_id'
      });
      this.belongsTo(models.sub_comment,{
        as: 'comment_sub_comment_vote',
        foreignKey: 'subComment_id'
        

      });
      
    }
  };
  sub_comment_vote.init({
    user_id: DataTypes.INTEGER,
    subComment_id: DataTypes.INTEGER,
    voted: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'sub_comment_vote',
  });
  return sub_comment_vote;
};