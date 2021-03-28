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
        foreignKey: 'tagId',
        through: 'post_tags'

      });
      this.belongsToMany(models.comment, {
        as: 'comments',
        foreignKey: 'tagId',
        through: 'post_tags'

      });
      this.belongsToMany(models.sub_comment, {
        as: 'sub_comments',
        foreignKey: 'tagId',
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