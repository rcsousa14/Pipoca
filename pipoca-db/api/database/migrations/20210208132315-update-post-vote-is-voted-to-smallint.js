'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn('post_votes', 'voted', {
      type: Sequelize.SMALLINT,
      defaultValue: 0,
      after: "post_id"
    });
    await queryInterface.addColumn('comment_votes', 'voted', {
      type: Sequelize.SMALLINT,
      defaultValue: 0,
      after: "comment_id"
    });
    await queryInterface.addColumn('sub_comment_votes', 'voted', {
      type: Sequelize.SMALLINT,
      defaultValue: 0,
      after: "sub_comment_id"
    });
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.removeColumn('post_votes', 'is_voted');
    await queryInterface.removeColumn('comment_votes', 'is_voted');
    await queryInterface.removeColumn('sub_comment_votes', 'is_voted');
  }
};
