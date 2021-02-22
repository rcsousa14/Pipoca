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
      phone_number: {
        type: Sequelize.STRING(20),
        allowNull: false,
        unique: {
          args: 'phone_number',
          msg: 'o número de telefone já existe'
        },
      },
      phone_carrier: {
        type: Sequelize.STRING(20)
      },
      role_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'roles', 
          key: 'id'
        },
        onUpdate: 'RESTRICT',
        onDelete: 'CASCADE'
      },
      username: {
        type: Sequelize.STRING(20),
        allowNull: false,
        unique: {
          args: 'username',
          msg: 'o nome de usuário já existe'
        },

      },
      avatar: {
        type: Sequelize.STRING
      },
      birthday: {
        type: Sequelize.STRING(15)
      },
      bio: {
        type: Sequelize.STRING(124)
      },
      fcm_token: {
        type: Sequelize.STRING,
        allowNull: false,
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