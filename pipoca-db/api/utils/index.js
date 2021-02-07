const jwt = require('jsonwebtoken');
require('dotenv').config();





exports.jwtToken  = { 

    createToken({ id, phone_number, role_id }) {
        return jwt.sign({ id, phone_number, role_id }, process.env.JWT_SECRET, {
            expiresIn: '7d'
        });

    },
     verifyToken(token) {
        return jwt.verify(token, process.env.JWT_SECRET, { expiresIn: '7d' });
        
    }

};


