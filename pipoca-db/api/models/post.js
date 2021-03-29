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
        foreignKey: 'user_id'
      });
      post.hasMany(models.post_vote, {
        as: 'post_votes',
        foreignKey: 'post_id'
      });
      post.hasMany(models.comment, {
        as: 'post_comments',
        foreignKey: 'post_id'
      });
      this.belongsToMany(models.tag, {
        as: 'tags',
        foreignKey: 'post_id',
        otherKey: 'tag_id',
        through: 'post_tags'

      });
      this.belongsToMany(models.link, {
        as: 'links',
        foreignKey: 'post_id',
        otherKey: 'link_id',
        through: 'post_links'

      });
    }
  };
  post.init({
    user_id: DataTypes.INTEGER,
    content: DataTypes.STRING(200),
    flags: DataTypes.INTEGER,
    is_flagged: DataTypes.BOOLEAN,
    coordinates: DataTypes.GEOMETRY('POINT'),
    is_deleted: DataTypes.BOOLEAN
  }, {
    sequelize,
    modelName: 'post',
  });
  return post;
};