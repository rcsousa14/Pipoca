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
        foreignKey: 'link_id',
        otherKey: 'post_id',
        through: 'post_links'

      });
      this.belongsToMany(models.comment, {
        as: 'comments',
        foreignKey: 'link_id',
        otherKey: 'comment_id',
        through: 'post_links'

      });
      this.belongsToMany(models.sub_comment, {
        as: 'sub_comments',
        foreignKey: 'link_id',
        otherKey: 'sub_comment_id',
        through: 'post_links'

      });
    }
  };
  link.init({
    url: DataTypes.STRING,
    
  }, {
    sequelize,
    modelName: 'link',
  });
  return link;
};