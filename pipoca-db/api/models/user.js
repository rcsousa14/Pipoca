'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class user extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
     user.belongsTo(models.role,{
       as: 'role',
       foreignKey: 'role_id'
     });
     user.hasMany(models.points,{
       as: 'user',
       foreignKey: 'user_id',
     })
    }
  };
  user.init({
    name: DataTypes.STRING,
    password: DataTypes.STRING,
    username: DataTypes.STRING,
    phone: DataTypes.STRING,
    gender: DataTypes.STRING,
    birthday: DataTypes.STRING,
    picture: DataTypes.STRING,
    points: DataTypes.INTEGER,
    wallet: DataTypes.INTEGER,
    fcm_token: DataTypes.STRING,
    role_id: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'user',
  });
  return user;
};