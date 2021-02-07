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
        foreignKey: 'user_id'
        

      });
      this.belongsTo(models.post,{
        as: 'post_vote',
        foreignKey: 'post_id'
        

      });
    }
  };
  post_vote.init({
    user_id: DataTypes.INTEGER,
    post_id: DataTypes.INTEGER,
    is_voted: DataTypes.BOOLEAN,
    
  }, {
    sequelize,
    modelName: 'post_vote',
  });
  return post_vote;
};