'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class post_vote extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      this.belongsTo(models.user,{
        as: 'user_vote',
        foreignKey: 'userId'
        

      });
      this.belongsTo(models.post,{
        as: 'post_vote',
        foreignKey: 'postId'
        

      });
    }
  };
  post_vote.init({
    userId: DataTypes.INTEGER,
    postId: DataTypes.INTEGER,
    voted: DataTypes.INTEGER,
    
  }, {
    sequelize,
    modelName: 'post_vote',
  });
  return post_vote;
};