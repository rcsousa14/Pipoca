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
      userId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'users', 
          key: 'id'
        },
        onUpdate: 'RESTRICT',
        onDelete: 'SET NULL'
      },
      subCommentId: {
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
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  down: async (queryInterface, Sequelize) => {
    await queryInterface.dropTable('sub_comment_votes');
  }
};