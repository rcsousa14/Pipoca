'use strict';
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('sub_comment_votes', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'users', 
          key: 'id'
        },
        onUpdate: 'RESTRICT',
        onDelete: 'SET NULL'
      },
      sub_comment_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'sub_comments', 
          key: 'id'
        },
        onUpdate: 'RESTRICT',
        onDelete: 'SET NULL'
      },
      voted: {
        type: Sequelize.INTEGER,
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
    await queryInterface.dropTable('sub_comment_votes');
  }
};