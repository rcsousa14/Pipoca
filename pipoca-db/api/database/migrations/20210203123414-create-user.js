'use strict';
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('users', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      name: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      username: {
        type: Sequelize.STRING,
        allowNull: false,
        unique: true,
      },
      password: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      phone: {
        type: Sequelize.STRING,
        unique:true,
      },
      gender: {
        type: Sequelize.STRING
      },
      birthday: {
        type: Sequelize.STRING
      },
      picture: {
        type: Sequelize.STRING
      },
      points: {
        type: Sequelize.INTEGER,
        defaultValue: 100,
        
      },
      wallet: {
        type: Sequelize.INTEGER,
        defaultValue: 0,
       
      },
      role_id: {
        type:Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'roles', 
          key: 'id'
        },
        defaultValue: 2,
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE'
      },
      fcm_token: {
        type: Sequelize.STRING,
        allowNull: false
      },
      created_at: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updated_at: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  down: async (queryInterface, Sequelize) => {
    await queryInterface.dropTable('users');
  }
};