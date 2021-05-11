'use strict';
module.exports = {
    up: async(queryInterface, Sequelize) => {
        await queryInterface.createTable('sub_comments', {
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
            reply_to_id: {
                type: Sequelize.INTEGER,
                allowNull: false,
                references: {
                    model: 'users',
                    key: 'id'
                },
                onUpdate: 'RESTRICT',
                onDelete: 'SET NULL'

            },
            comment_id: {
                type: Sequelize.INTEGER,
                allowNull: false,
                references: {
                    model: 'comments',
                    key: 'id'
                },
                onUpdate: 'RESTRICT',
                onDelete: 'SET NULL'

            },
            content: {
                type: Sequelize.STRING(200)
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

            created_at: {
                allowNull: false,
                type: Sequelize.DATE
            },
            updated_at: {
                allowNull: false,
                type: Sequelize.DATE
            },
            deleted_at: {
                type: Sequelize.DATE
            }
        });
    },
    down: async(queryInterface, Sequelize) => {
        await queryInterface.dropTable('sub_comments');
    }
};