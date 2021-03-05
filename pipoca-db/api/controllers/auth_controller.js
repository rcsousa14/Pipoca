import jwt from 'jsonwebtoken';
const models = require("../models");
const auth = require("../utils");
const nodemailer = require('nodemailer');
const ejs = require("ejs");
import fs from 'fs';
import path from 'path';
require('dotenv').config();
const Sequelize = require('sequelize');
const Op = Sequelize.Op;


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
        if (newUser) {
            const token = auth.jwtToken.createToken(newUser);
            const host = req.headers.host;
            const http = req.protocol;
            const logo = "./public/images/red.png";
            const link = `${http}://localhost:4000/v1/auth/activate-account/${token}`
            let transporter = nodemailer.createTransport({
                service: 'gmail',
                // host: process.env.RESET_HOST,
                // port: process.env.RESET_PORT,
                // secure: process.env.RESET_ISSECURE, // true for 465, false for other ports
                auth: {
                    user: process.env.RESET_USERNAME, // generated ethereal user
                    pass: process.env.RESET_PASSWORD, // generated ethereal password
                },
            });
            ejs.renderFile(path.join(__dirname, '../../views', 'email.ejs'), { name: '', link: link, logo: logo, confirmation: true, title: 'Confirmação da Conta' }, async function (err, data) {
                if (err) {
                    return res.status(400).send({ message: `Tenta novamente erro no link: ${err}` });
                } else {
                    let mailOptions = {

                        from: 'NO-REPLY@pipoca.ao',
                        to: email,
                        subject: 'Confirmação da Conta :: pipoca-v1.0.0',
                        text: link,
                        // attachments: [{
                        //     filename: 'red.png',
                        //     path: './public/images/red.png',
                        //     cid: 'logo'

                        // }],
                        html: data
                    }
                    transporter.sendMail(mailOptions, function (err, data) {
                        if (err) {
                            res.send({ message: `Tenta novamente : ${err} ` });
                        } else {
                            res.send(data);

                        }
                    });

                    return res.status(201).send({
                        message: "Bem-vindo à pipoca🍿. Verifique seu e-mail para activar sua conta!😄",
                        token,
                    });
                }
            });

        }

    } catch (error) {
        return res.status(500).json({
            status: 500,
            message: error.message,
        });
    }
};

exports.confirmation = async (req, res) => {
    try {
        const { token } = req.params
        if (token) {
            const decoded = auth.jwtToken.verifyToken(token);
            const user = await models.user.findByPk(decoded.id);
            if (user.active == false) {
                const update = await models.user.update({ active: true }, { where: { id: user.id } })
                if (update) {
                    res.render('reset', { msg: 'Conta activada com successo! Ja pode pipocar 🍿' })
                }
            }

            return res.render('reset', { msg: '422: token de redefinição de senha é inválido ou expirou 💩!' })
        }
    } catch (error) {
        return res.status(500).json({
            status: 500,
            message: error.message,
        });
    }
}

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;

        const user = await models.user.findOne({
            where: { email: email }
        });
        if (user) {
            if (password && passRegex.test(password) && auth.comparePassword(password, user.password)) {
                const token = auth.jwtToken.createToken(user);
                return res.status(200).send({
                    message: "welcome back to Pipoca 🍿 use the token to gain access!😄",
                    token,
                });
            }
            return res.status(400).send({ message: "senha incorrecta" });
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
        const [user, created] = await models.user.findOrCreate({ email, avatar, type, active: true }, { where: { email: email } });
        const token = auth.jwtToken.createToken(user);
        if (created) {
            return res.status(200).send({
                message: "welcome back to Pipoca 🍿 use the token to gain access!😄",
                token,
            });
        }
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

exports.forgot = async (req, res) => {


    try {

        const { email } = req.body;

        const user = await models.user.findOne({
            where: { email: email }
        });
        if (!user) {
            return res.status(400).send({ message: 'usuario nao existe!' });
        }
        const { username } = user;
        const token = auth.jwtToken.passToken(user);
        const host = req.headers.host;
        const http = req.protocol;
        const logo = "/public/images/red.png";
        const link = `${http}://localhost:4000/v1/auth/reset-password?token=${token}`;
        let transporter = nodemailer.createTransport({
            service: 'gmail',
            // host: process.env.RESET_HOST,
            // port: process.env.RESET_PORT,
            // secure: process.env.RESET_ISSECURE, // true for 465, false for other ports
            auth: {
                user: process.env.RESET_USERNAME, // generated ethereal user
                pass: process.env.RESET_PASSWORD, // generated ethereal password
            },
        });

        ejs.renderFile(path.join(__dirname, '../../views', 'email.ejs'), { name: username, link: link, logo: logo, confirmation: false, title: 'Redefinição de senha' }, async function (err, data) {
            if (err) {
                return res.status(400).send({ message: `Tenta novamente erro no link: ${err}` });
            } else {
                let mailOptions = {

                    from: 'NO-REPLY@pipoca.ao',
                    to: email,
                    subject: 'Redefinição de senha :: pipoca-v1.0.0',
                    text: link,
                    attachments: [{
                        filename: 'red.png',
                        path: './public/images/red.png',
                        cid: 'logo'

                    }],
                    html: data
                }
                transporter.sendMail(mailOptions, function (err, data) {
                    if (err) {
                        res.send({ message: `Tenta novamente : ${err} ` });
                    } else {
                        res.send(data);

                    }
                });
                var date = Date.now() + 600000; // 10m
                await models.user.update({ reset_password_token: token, reset_password_expiration: date }, { where: { email: email } });
                return res.status(200).send({ message: '📧Email Enviado! Verifique seu e-mail.' });
            }
        });






    } catch (error) {
        return res.status(500).json({
            status: 500,
            message: error.message,
        });
    }



};
exports.reset = async (req, res) => {
    try {


        const { token } = req.query;

        return res.render('reset', { token: token, msg: '' });



    } catch (error) {
        return res.status(500).json({
            status: 500,
            message: error.message,
        });
    }
};
exports.send = async (req, res) => {
    try {


        const { password, confirmation, token } = req.body;

        const verify = auth.jwtToken.verifyPassToken(token);
        if (token && verify) {


            const user = await models.user.findOne({ where: { reset_password_token: token, reset_password_expiration: { [Op.gt]: Date.now() } } });
            if (!user) {
                return res.render('reset', { msg: '422: token de redefinição de senha é inválido ou expirou 💩!' })
            }


            if (password === confirmation) {
                const hash = auth.hashPassword(password);
                const date = new Date(0);
                const update = await models.user.update({ password: hash, reset_password_token: '', reset_password_expiration: date }, { where: { id: user.id } })
                if (update) {
                    return res.render('reset', { msg: 'Sua senha foi atualizada com sucesso!\n De volta a pipocar 🥳' })
                }
                return res.render('reset', { msg: 'Erro desconhecido' })
            }


            return res.render('reset', { msg: 'Sua senha de confirmação não é a mesma que sua senha' })

        }



        return res.status(401).send('401: Unauthorized 💩!');

    } catch (error) {
        return res.status(500).json({
            status: 500,
            message: error.message,
        });
    }
};

