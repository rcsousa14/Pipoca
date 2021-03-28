'use strict';
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('links', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      url: {
        type: Sequelize.STRING
      },
      title: {
        type: Sequelize.STRING
      },
      siteName: {
        type: Sequelize.STRING
      },
      description: {
        type: Sequelize.STRING
      },
      images: {
        type: Sequelize.ARRAY(Sequelize.STRING)
      },
      mediaType: {
        type: Sequelize.STRING
      },
      contentType: {
        type: Sequelize.STRING
      },
      videos: {
        type: Sequelize.ARRAY(Sequelize.STRING)
      },
      favicons: {
        type:Sequelize.ARRAY(Sequelize.STRING)
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