import jwt from 'jsonwebtoken';
import ApiError from "../errors/api_error";
require('dotenv').config();


export default (req, res, next) => {
    if (!req.headers.authorization) {
        next(ApiError.unauthorisedInvalidException("desautorizado : 💩"))
        return;
    }

    const { token } = req.query;

    jwt.verify(token, process.env.JWT_SECRET, { expiresIn: '7d' }, (err, decoded) => {
        if (err) {
            next();
            return;


        }
        return res.status(200).json({
            success: true,
            message: "Bem-vindo ao Pipoca",
            token,
        });
    })
}