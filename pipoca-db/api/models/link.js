'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class link extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      this.belongsToMany(models.post, {
        as: 'posts',
        foreignKey: 'linkId',
        through: 'post_links'

      });
      this.belongsToMany(models.comment, {
        as: 'comments',
        foreignKey: 'linkId',
        through: 'post_links'

      });
      this.belongsToMany(models.sub_comment, {
        as: 'sub_comments',
        foreignKey: 'linkId',
        through: 'post_links'

      });
    }
  };
  link.init({
    url: DataTypes.STRING,
    title: DataTypes.STRING,
    siteName: DataTypes.STRING,
    description: DataTypes.STRING,
    images: DataTypes.ARRAY(DataTypes.STRING),
    mediaType: DataTypes.STRING,
    contentType: DataTypes.STRING,
    videos: DataTypes.ARRAY(DataTypes.STRING),
    favicons: DataTypes.ARRAY(DataTypes.STRING)
  }, {
    sequelize,
    modelName: 'link',
  });
  return link;
};