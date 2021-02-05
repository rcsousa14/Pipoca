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
      post.belongsToMany(models.point, {
        foreignKey: 'post_id',
        through: 'post_points',
        as: 'points'
      });
      post.belongsTo(models.user,{
        foreignKey: 'user_id',
        as: 'user'

      });
    }
  };
  post.init({
    user_id: DataTypes.INTEGER,
    post_text: DataTypes.STRING,
    links: DataTypes.ARRAY(DataTypes.STRING),
    tags: DataTypes.ARRAY(DataTypes.STRING),
    coordinates: DataTypes.GEOMETRY,
    isNear: DataTypes.BOOLEAN,
    isFlagged: DataTypes.BOOLEAN,
    flag: DataTypes.INTEGER,
    total_points: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'post',
  });
  return post;
};