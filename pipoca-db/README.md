# 🗺️ RoadMap 
- [ ] need to finish the controllers
- [ ] need to figure out how to work with coordinates and node
- [ ] if I figure out the post controller the comments and subcomments will be easy to do
- [ ] need to learn how to make test with jest
- [ ] need to learn how to make swagger ui for documentation
- [ ] need to connect it with the app

## for later on to do migration add 
```javascript
module.exports = {
  up: function(queryInterface, Sequelize) {
    // logic for transforming into the new state
    return queryInterface.addColumn(
      'Todo',
      'completed',
     Sequelize.BOOLEAN
    );

  },

  down: function(queryInterface, Sequelize) {
    // logic for reverting the changes
    return queryInterface.removeColumn(
      'Todo',
      'completed'
    );
  }
} 
```

## another way to do it 
```javascript
module.exports = {
  up: (queryInterface, Sequelize) => {
    return Promise.all([
      queryInterface.addColumn(
        'tableName',
        'columnName1',
        {
          type: Sequelize.STRING
        }
      ),
      queryInterface.addColumn(
        'tableName',
        'columnName2',
        {
          type: Sequelize.STRING
        }
      ),
    ]);
  },

  down: (queryInterface, Sequelize) => {
    return Promise.all([
      queryInterface.removeColumn('tableName', 'columnName1'),
      queryInterface.removeColumn('tableName', 'columnName2')
    ]);
  }
};
```