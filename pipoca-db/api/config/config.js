require('dotenv').config();

module.exports = {
    development: {
        username: process.env.DB_DEV_USER,
        password: process.env.DB_DEV_PASS,
        database: process.env.DB_DEV,
        host: process.env.DB_DEV_HOST,
        port: process.env.DB_DEV_PORT,
        dialect: "postgres",
        define: {
            timestamps: true,
            underscored: true,
        }
    },
    production: {
        use_env_variable: process.env.DATABASE_URL,

    }
}