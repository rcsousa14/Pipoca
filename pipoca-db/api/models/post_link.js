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
    postId: DataTypes.INTEGER,
    commentId: DataTypes.INTEGER,
    subCommentId: DataTypes.INTEGER,
    linkId: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'post_link',
  });
  return post_link;
};