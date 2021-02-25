const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
require('dotenv').config();





exports.jwtToken = {

    createToken({ id, phone_number, role_id }) {
        return jwt.sign({ id, phone_number, role_id }, process.env.JWT_SECRET, {
            expiresIn: '365d'
        });

    },
    verifyToken(token) {
        return jwt.verify(token, process.env.JWT_SECRET, { expiresIn: '365d' });

    }

};


export const hashPassword = (password) => bcrypt.hashSync(password, 10);
export const comparePassword = (password, hash) => bcrypt.compareSync(password, hash);