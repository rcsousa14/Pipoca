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
    postId: DataTypes.INTEGER,
    tagId: DataTypes.INTEGER,
    commentId: DataTypes.INTEGER,
    subCommentId: DataTypes.INTEGER,
  }, {
    sequelize,
    modelName: 'post_tag',
  });
  return post_tag;
};