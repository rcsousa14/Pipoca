'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class post extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      post.belongsTo(models.user, {
        as: 'creator',
        foreignKey: 'userId'
      });
      post.hasMany(models.post_vote, {
        as: 'post_votes',
        foreignKey: 'postId'
      });
      post.hasMany(models.comment, {
        as: 'post_comments',
        foreignKey: 'postId'
      });
      this.belongsToMany(models.tag, {
        as: 'tags',
        foreignKey: 'postId',
        through: 'post_tags'

      });
      this.belongsToMany(models.link, {
        as: 'links',
        foreignKey: 'postId',
        through: 'post_links'

      });
    }
  };
  post.init({
    userId: DataTypes.INTEGER,
    content: DataTypes.STRING(200),
    flags: DataTypes.INTEGER,
    isFlagged: DataTypes.BOOLEAN,
    coordinates: DataTypes.GEOMETRY('POINT'),
    isDeleted: DataTypes.BOOLEAN
  }, {
    sequelize,
    modelName: 'post',
  });
  return post;
};