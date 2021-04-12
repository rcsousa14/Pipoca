import jwt from 'jsonwebtoken';
import models from '../models';
import ApiError from "../errors/api_error";
require('dotenv').config();


export default (req, res, next) => {
    if (!req.headers.authorization) {
        return res.status(401).json({ message: ` Unauthorized 💩! ${err}` });
    }

    const token = req.headers.authorization.split(' ')[1];
    jwt.verify(token, process.env.JWT_SECRET, { expiresIn: '7d' }, (err, decoded) => {
        if (err) {
            next(ApiError.unauthorisedInvalidException("desautorizado : 💩"));
            return;


        }
        req.decoded = decoded;
        models.user.findByPk(decoded.id)
            .then((user) => {
                if (!user) {
                    next(ApiError.unauthorisedValidException("desautorizado : 💩"));
                    return;
                }

                next();
            })
    })
}