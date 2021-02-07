'use strict';

const faker = require('faker');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    let data = [];
    let amount = 50;
    while(amount --){
      let date = new Date();
      data.push({
        username: faker.internet.userName(),
        phone_number:faker.phone.phoneNumber('+244#########'),
        phone_carrier: 'unitel',
        birthday: '2000-01-01',
        avatar: faker.internet.avatar(),
        bio: faker.lorem.words(5),
        fcm_token:faker.random.alphaNumeric(65),
        role_id: 2,
        created_at: date,
        updated_at: date
      })
    }
    await queryInterface.bulkInsert('users', data, {});
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('users', null, {});
  }
};
