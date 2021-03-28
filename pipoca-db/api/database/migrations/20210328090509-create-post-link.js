'use strict';
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('post_links', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      postId: {
        type: Sequelize.INTEGER,
        references: {
          model: 'posts', 
          key: 'id'
        },
        onUpdate: 'RESTRICT',
        onDelete: 'SET NULL'
      
      },
      commentId: {
        type: Sequelize.INTEGER,
        references: {
          model: 'comments', 
          key: 'id'
        },
        onUpdate: 'RESTRICT',
        onDelete: 'SET NULL'
      },
      subCommentId: {
        type: Sequelize.INTEGER,
        references: {
          model: 'sub_comments', 
          key: 'id'
        },
        onUpdate: 'RESTRICT',
        onDelete: 'SET NULL'
      },
      linkId: {
        type: Sequelize.INTEGER
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
    await queryInterface.dropTable('post_links');
  }
};