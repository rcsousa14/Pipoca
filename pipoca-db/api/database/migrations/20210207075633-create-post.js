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
          model: 'users', 
          key: 'id'
        },
        onUpdate: 'RESTRICT',
        onDelete: 'SET NULL'
      },
      content: {
        type: Sequelize.STRING(200),
        allowNull:false
      },
      links: {
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
      coordinates: {
        type: Sequelize.GEOMETRY('POINT'),
        allowNull: false
      },
      is_deleted: {
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
    await queryInterface.dropTable('posts');
  }
};