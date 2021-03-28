'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    let date = new Date();

    await queryInterface.bulkInsert('roles', [
      {
        role: 'admin',
        created_at: date,
        updated_at: date
      },
      {
        role: 'regular',
        created_at: date,
        updated_at: date
      },
    ]);

  },

  down: async (queryInterface, Sequelize) => {
    /**
     * Add commands to revert seed here.
     *
     * Example:
     * await queryInterface.bulkDelete('People', null, {});
     */
  }
};
