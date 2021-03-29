'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class post_tag extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      
    }
  };
  post_tag.init({
    post_id: DataTypes.INTEGER,
    comment_id: DataTypes.INTEGER,
    sub_comment_id: DataTypes.INTEGER,
    tag_id: DataTypes.INTEGER,
    
  }, {
    sequelize,
    modelName: 'post_tag',
  });
  return post_tag;
};