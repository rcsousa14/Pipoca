import jwt from 'jsonwebtoken';
const models = require("../models");
const auth = require("../utils");
require('dotenv').config();


exports.signup = async (req, res) => {
    try {
        const { fcm_token, email, password } = req.body;

        const hash = auth.hashPassword(password);

        const checkname = await models.user.findOne({
            where: {
                email: email,
            },
        });
        if (checkname) {
            return res
                .status(409)
                .send({ message: "😞 O nome de usuário já existe" });
        }
        const { id } = await models.role.findOne({ where: { role: "regular" } });
        const newUser = await models.user.create({
            fcm_token,
            email,
            password: hash,
            role_id: id,
            type: 'email/password'
        });
        const token = auth.jwtToken.createToken(newUser);

        return res.status(201).send({
            message: "welcome to Pipoca 🍿 use the token to gain access!😄",
            token,
        });
    } catch (error) {
        return res.status(500).json({
            status: 500,
            message: error.message,
        });
    }
};

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;

        const user = await models.user.findOne({
            where: { email: email }
        });
        if (user && auth.comparePassword(password, user.password)) {
            const token = auth.jwtToken.createToken(user);
            return res.status(200).send({
                message: "welcome back to Pipoca 🍿 use the token to gain access!😄",
                token,
            });
        }

        return res.status(400).send({ message: "usuario nao existe!" });
    } catch (error) {
        return res.status(500).json({
            status: 500,
            message: error.message,
        });
    }
};

exports.social = async (req, res) => {
    try {
        const { email, avatar, type } = req.body;
        const [user, created] = await models.user.findOrCreate({ email, avatar, type }, { where: { email: email } });
        const token = auth.jwtToken.createToken(user);
        if (created || !created) {
            return res.status(200).send({
                message: "welcome back to Pipoca 🍿 use the token to gain access!😄",
                token,
            });
        }
    } catch (error) {
        return res.status(500).json({
            status: 500,
            message: error.message,
        });
    }
};

exports.reset = async (req, res) => {
    try {
        const { email } = req.body;
        const user = await models.user.findOne({ where: { email: email } });
        const token = auth.jwtToken.createToken(user);
        // send email with token as a query
        // if (created || !created) {
        //     return res.status(200).send({
        //         message: "welcome back to Pipoca 🍿 use the token to gain access!😄",
        //         token,
        //     });
        // }
    } catch (error) {
        return res.status(500).json({
            status: 500,
            message: error.message,
        });
    }
};

exports.update = async (req, res) => {
    try {
        const { password, confirmation } = req.body;
        const token = req.query;

        jwt.verify(token, process.env.JWT_SECRET, { expiresIn: '365d' }, (err, decoded) => {
            if (err) {
                return res.status(401).send(`401: Unauthorized 💩! ${err}`);
            }
            if (password === confirmation) {
                const hash = auth.hashPassword(password);
                req.decoded = decoded;
                await models.user.update({password: hash}, { where: { id: decoded.id } });
            }


        })
        
    } catch (error) {
        return res.status(500).json({
            status: 500,
            message: error.message,
        });
    }
};