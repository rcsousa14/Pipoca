'use strict';
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('post_points', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      post_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model:'posts',
          key: 'id',
          onUpdate: 'CASCADE',
          onDelete: 'CASCADE' 
         }
      },
      point_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model:'posts',
          key: 'id',
          onUpdate: 'CASCADE',
          onDelete: 'CASCADE' 
         }
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
    await queryInterface.dropTable('post_points');
  }
};