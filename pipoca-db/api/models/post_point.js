'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class user_point extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  };
  user_point.init({
    post_id: DataTypes.INTEGER,
    point_id: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'post_point',
  });
  return user_point;
};