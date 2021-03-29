'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class post_link extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  };
  post_link.init({
    post_id: DataTypes.INTEGER,
    comment_id: DataTypes.INTEGER,
    sub_comment_id: DataTypes.INTEGER,
    link_id: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'post_link',
  });
  return post_link;
};