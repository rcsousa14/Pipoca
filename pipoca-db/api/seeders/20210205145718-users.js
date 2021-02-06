'use strict';
const bcrypt = require('bcryptjs');
const faker = require('faker');


module.exports = {
  up: async (queryInterface, Sequelize) => {

    let data = [];
    let amount = 50;
    
  let password  = 'Pipoc@123';
    while(amount --){
      let date = new Date();
      let hash = bcrypt.hashSync(password, 10);
      let newName = `${faker.name.firstName()} ${faker.name.lastName()}`;
      
      data.push({
        
        name: newName,
        username: faker.internet.userName(),
        password: hash,
        phone: faker.phone.phoneNumber('#########'),
        gender: faker.name.gender(),
        birthday: faker.date.past(1990, '1990-01-01'),
        picture: faker.internet.avatar(),
        points: faker.random.number(),
        wallet: faker.random.number(),
        fcm_token: faker.random.alphaNumeric(65),
        role_id: 3,
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
