'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class tag extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      this.belongsToMany(models.post, {
        as: 'posts',
        foreignKey: 'tag_id',
        otherKey: 'post_id',
        through: 'post_tags'

      });
      this.belongsToMany(models.comment, {
        as: 'comments',
        foreignKey: 'tag_id',
        otherKey: 'comment_id',
        through: 'post_tags'

      });
      this.belongsToMany(models.sub_comment, {
        as: 'sub_comments',
        foreignKey: 'tag_id',
        otherKey: 'sub_comment_id',
        through: 'post_tags'

      });
    }
  };
  tag.init({
    hash: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'tag',
  });
  return tag;
};