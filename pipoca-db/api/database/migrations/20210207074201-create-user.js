'use strict';
module.exports = {
    up: async(queryInterface, Sequelize) => {
        await queryInterface.createTable('users', {
            id: {
                allowNull: false,
                autoIncrement: true,
                primaryKey: true,
                type: Sequelize.INTEGER
            },
            email: {
                type: Sequelize.STRING,
                unique: true,
                allowNull: false,
                validate: {
                    isEmail: true
                }
            },
            password: {
                type: Sequelize.STRING(64),
                is: /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/i
            },
            role_id: {
                type: Sequelize.INTEGER,
                allowNull: false,
                references: {
                    model: 'roles',
                    key: 'id'
                },
                onUpdate: 'RESTRICT',
                onDelete: 'CASCADE'
            },
            username: {
                type: Sequelize.STRING(20),
                unique: true,
            },
            avatar: {
                type: Sequelize.STRING
            },
            birthday: {
                type: Sequelize.STRING(15)
            },
            bio: {
                type: Sequelize.STRING(124)
            },
            fcm_token: {
                type: Sequelize.STRING,

            },
            type: {
                type: Sequelize.STRING(20),
                allowNull: false,
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
    down: async(queryInterface, Sequelize) => {
        await queryInterface.dropTable('users');
    }
};