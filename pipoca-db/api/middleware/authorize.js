import jwt from 'jsonwebtoken';
import models from '../models';
require('dotenv').config();


export default (req, res, next) => {
    if (!req.headers.authorization) {
        return res.status(401).json({message:` Unauthorized 💩! ${err}`});
    }
 
    const token = req.headers.authorization.split(' ')[1];
    jwt.verify(token, process.env.JWT_SECRET, { expiresIn: '7d' }, (err, decoded) => {
        if (err) {
            return res.status(401).json({message:` Unauthorized 💩! ${err}`});
        }
        req.decoded = decoded;
         models.user.findByPk(decoded.id)
            .then((user) => {
                if (!user) {
                    return res.status(401).json({message:` Unauthorized 💩! ${err}`});
                }
               
                next();
            })
    })
}