const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
require('dotenv').config();





exports.jwtToken  = { 

    createToken({ id, username }) {
        return jwt.sign({ id, username }, process.env.JWT_SECRET, {
            expiresIn: '7d'
        });

    },
     verifyToken(token) {
        return jwt.verify(token, process.env.JWT_SECRET, { expiresIn: '7d' });
        
    }

};


export const hashPassword = (password) => bcrypt.hashSync(password, 10);
export const comparePassword = (password, hash) => bcrypt.compareSync(password, hash);