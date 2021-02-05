'use strict';
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('posts', {
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
          model:'users',
          key:'id',
          onUpdate: 'CASCADE',
          onDelete:'CASCADE'
        }
      },
      post_text: {
        type: Sequelize.STRING(200),
        allowNull: false,
      },
      links: {
        type: Sequelize.ARRAY(Sequelize.STRING)
      },
      tags: {
        type: Sequelize.ARRAY(Sequelize.STRING)
      },
      coordinates: {
        type: Sequelize.GEOMETRY('POINT')
      },
      isNear: {
        type: Sequelize.BOOLEAN
      },
      isFlagged: {
        type: Sequelize.BOOLEAN,
        defaultValue: false
      },
      flag: {
        type: Sequelize.INTEGER
      },
      total_points: {
        type: Sequelize.INTEGER
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
    await queryInterface.dropTable('posts');
  }
};