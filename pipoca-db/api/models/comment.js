'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class comment extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      comment.belongsTo(models.user, {
        as: 'creator',
        foreignKey: 'user_id'
      });
      comment.belongsTo(models.post, {
        as: 'post_comment',
        foreignKey: 'post_id'
      });
      comment.hasMany(models.comment_vote, {
        as: 'comment_votes',
        foreignKey: 'comment_id',

      });
      comment.hasMany(models.sub_comment, {
        as: 'comment_sub_comments',
        foreignKey: 'comment_id'
      });
      this.belongsToMany(models.link, {
        as: 'links',
        foreignKey: 'comment_id',
        otherKey: 'link_id',
        through: 'post_links'

      });
      this.belongsToMany(models.tag, {
        as: 'tags',
        foreignKey: 'comment_id',
        otherKey: 'tag_id',
        through: 'post_tags'
      });

    }
  };
  comment.init({
    user_id: DataTypes.INTEGER,
    post_id: DataTypes.INTEGER,
    content: DataTypes.STRING(200),
    flags: DataTypes.INTEGER,
    is_flagged: DataTypes.BOOLEAN,
    coordinates: DataTypes.GEOMETRY('POINT'),
   
  }, {
    sequelize,
    modelName: 'comment',
    paranoid: true,
    timestamps: true,
    deletedAt: 'deleted_at'
  });
  return comment;
};