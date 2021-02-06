'use strict';
const faker = require('faker');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    let data = [];
    let amount = 30;
    var userId = Math.floor(Math.random() *(1000 - 33 + 1) + 33);
    while(amount --){
      let date = new Date();
      let tags = `# ${faker.lorem.word(1)}`;
     
      data.push({
        user_id: userId,
        post_text: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec qu',
        links: [faker.internet.domainSuffix()],
        tags: [tags],
        coordinates: Sequelize.fn('ST_GeomFromText', 'POINT(13.234444 -8.838333)'),
        flag: 0,
        total_points: 0,
        created_at: date,
        updated_at: date
      })
    }
     
     await queryInterface.bulkInsert('posts', data, {});
  
  },

  down: async (queryInterface, Sequelize) => {
   
     
     await queryInterface.bulkDelete('posts', null, {});
   
  }
};
