'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class point extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      point.belongsTo(models.role,{
        as: 'user',
        foreignKey: 'user_id',
      });
      point.belongsToMany(models.post, {
        foreignKey: 'point_id',
        through: 'post_points',
        as: 'posts'
      });
    }
  };
  point.init({
    user_id: DataTypes.INTEGER,
    isPoint: DataTypes.BOOLEAN
  }, {
    sequelize,
    modelName: 'point',
  });
  return point;
};