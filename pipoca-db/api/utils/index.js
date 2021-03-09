const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
require('dotenv').config();





exports.jwtToken = {

    createToken({ id, email }) {
        return jwt.sign({ id, email }, process.env.JWT_SECRET, {
            expiresIn: '7d'
        });

    },
    verifyToken(token) {
        return jwt.verify(token, process.env.JWT_SECRET, { expiresIn: '7d' });

    },
    refreshToken({ date }) {
        
        return jwt.sign({ date }, process.env.JWT_SECRET_REFRESH);
    },
    verifyRefreshToken(token) {
        return jwt.verify(token, process.env.JWT_SECRET_REFRESH);
    },
    passToken({ id }) {
        return jwt.sign({ id }, process.env.JWT_SECRET_PASS, {
            expiresIn: '10m'
        });

    },
    verifyPassToken(token) {
        return jwt.verify(token, process.env.JWT_SECRET_PASS, { expiresIn: '10m' });

    }

};


export const hashPassword = (password) => bcrypt.hashSync(password, 10);
export const comparePassword = (password, hash) => bcrypt.compareSync(password, hash);