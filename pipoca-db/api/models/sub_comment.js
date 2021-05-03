'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class sub_comment extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      this.belongsTo(models.user, {
        as: 'creator',
        foreignKey: 'user_id'
      });
      this.belongsTo(models.user, {
        as: 'replyTo',
        foreignKey: 'user_id'
      });
      this.belongsTo(models.comment, {
        as: 'comment_sub_comment',
        foreignKey: 'comment_id'
      });
      this.hasMany(models.sub_comment_vote, {
        as: 'sub_comment_votes',
        foreignKey: 'subComment_id'
      });
      this.belongsToMany(models.link, {
        as: 'links',
        foreignKey: 'post_id',
        otherKey: 'link_id',
        through: 'post_links'

      });
      this.belongsToMany(models.tag, {
        as: 'tags',
        foreignKey: 'post_id',
        otherKey: 'tag_id',
        through: 'post_tags'

      });

    }
  };
  sub_comment.init({
    user_id: DataTypes.INTEGER,
    comment_id: DataTypes.INTEGER,
    content: DataTypes.STRING(200),
    flags: DataTypes.INTEGER,
    reply_to_id: DataTypes.INTEGER,
    is_flagged: DataTypes.BOOLEAN,
    coordinates: DataTypes.GEOMETRY('POINT'),
   
  }, {
    sequelize,
    modelName: 'sub_comment',
    paranoid: true,
    timestamps: true,
    deletedAt: 'deleted_at'
  });
  return sub_comment;
};