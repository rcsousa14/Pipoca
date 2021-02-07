'use strict';
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('sub_comments', {
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
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE'
      
      },
      comment_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'comments', 
          key: 'id'
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE'
      
      },
      content: {
        type: Sequelize.STRING(200)
      },
      links: {
        type: Sequelize.ARRAY(Sequelize.STRING)
      },
      tags: {
        type: Sequelize.ARRAY(Sequelize.STRING)
      },
      flags: {
        type: Sequelize.INTEGER,
        defaultValue: 0
      },
      is_flagged: {
        type: Sequelize.BOOLEAN,
        defaultValue: false
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
    await queryInterface.dropTable('sub_comments');
  }
};