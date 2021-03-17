const models = require("../models");
const { v4: uuidv4 } = require("uuid");
const auth = require("../utils");
const nodemailer = require('nodemailer');
const nodemailerSendgrid = require('nodemailer-sendgrid');
const ejs = require("ejs");
import path from 'path';
require('dotenv').config();
const Sequelize = require('sequelize');
const Op = Sequelize.Op;




exports.signup = async(req, res) => {
    try {
        const { fcm_token, email, password } = req.body;

        const refreshToken = uuidv4();
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
        const user = await models.user.create({
            fcm_token,
            email,
            refresh_token: refreshToken,
            password: hash,
            role_id: id,
            type: 'email/password'
        });
        if (user) {

            const token = auth.jwtToken.createToken(user);
            const host = req.headers.host;
            const http = req.protocol;
            const logo = "./public/images/red.png";
            const link = `${http}://${host}/v1/auth/activate-account/${token}`
            let transporter = nodemailer.createTransport(
                nodemailerSendgrid({
                    apiKey: process.env.SEND_GRID
                })
            );
            ejs.renderFile(path.join(__dirname, '../../views', 'email.ejs'), { name: '', link: link, logo: logo, confirmation: true, title: 'Confirmação da Conta' }, async function(err, data) {
                if (err) {
                    return res.status(400).send({ message: `Tenta novamente erro no link: ${err}` });
                } else {
                    let mailOptions = {

                        from: 'Ruben Sousa 😀 <coverxstories@gmail.com>',
                        to: email,
                        subject: 'Confirmação da Conta :: pipoca-v1.0.0',
                        text: link,
                        attachments: [{
                            filename: 'red.png',
                            path: './public/images/red.png',
                            cid: 'logo'

                        }],
                        html: data
                    }
                    transporter.sendMail(mailOptions, function(err, data) {
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

exports.confirmation = async(req, res) => {
    try {
        const { token } = req.params
        if (token) {
            const decoded = auth.jwtToken.verifyToken(token);
            console.log(decoded);
            const user = await models.user.findByPk(decoded.id);
            if (user.active == false) {
                const update = await models.user.update({ active: true }, { where: { id: user.id } })
                if (update) {
                    res.render('reset', { msg: 'Conta activada com successo! Ja pode pipocar 🍿', title: 'Confirmação da conta' })
                }
            }

            return res.render('reset', { msg: '422: token de redefinição de senha é inválido ou expirou 💩!', title: 'Confirmação da conta' })
        }
    } catch (error) {
        return res.status(500).json({
            status: 500,
            message: error.message,
        });
    }
}

exports.login = async(req, res) => {
    try {
        const { email, password } = req.body;

        const user = await models.user.findOne({
            where: { email: email }
        });
        if (user && user.refresh_token != 'blocked') {
            if (password && auth.comparePassword(password, user.password)) {
                const token = auth.jwtToken.createToken(user);
                const refreshToken = uuidv4();
                const update = await models.user.update({ refresh_token: refreshToken }, { where: { id: user.id } });
                if (update) {
                    return res.status(200).send({
                        message: "welcome back to Pipoca 🍿 use the token to gain access!😄",
                        token,
                    });
                }
                return res.status(400).send({
                    message: "Failed to update",

                });
            }
            return res.status(400).send({ message: "senha incorrecta" });
        }

        return res.status(400).send({
            message: "usuário não existe!"
        });
    } catch (error) {
        return res.status(500).json({
            status: 500,
            message: error.message,
        });
    }
};

exports.social = async(req, res) => {
    try {
        const { email, avatar, type, fcm_token, } = req.body;
        const { id } = await models.role.findOne({ where: { role: "regular" } });
        const refreshToken = uuidv4();
        const [user, created] = await models.user.findOrCreate({
            defaults: { email, avatar, type, role_id: id },
            //test this out to see if it works
            where: { email: email }
        });
        const token = auth.jwtToken.createToken(user);
        const username = `user${user.id}`;
        if (!created) {
            if (user.type != type) {
                return res.status(401).send({
                    message: "seu e-mail está associado a uma conta diferente!🤔"
                })
            }
            if (user.refresh_token != 'blocked') {

                const updated = await models.user.update({ refresh_token: refreshToken, fcm_token: fcm_token, active: true, username: username }, { where: { id: user.id } });
                if (updated) {
                    return res.status(200).send({
                        message: "welcome back to Pipoca 🍿 use the token to gain access!😄",
                        token,
                    });
                }
                return res.status(401).send({
                    message: "unknown error"
                })


            }
            return res.status(401).send({
                message: "Foste bloqueado devido a violação de uso!🙅🏾‍♀️ ",

            });

        }
        const updated = await models.user.update({ refresh_token: refreshToken, fcm_token: fcm_token, active: true, username: username }, { where: { id: user.id } });
        if (updated) {
            return res.status(201).send({
                message: "welcome to Pipoca 🍿 use the token to gain access!😄",
                token,
            });
        }
        return res.status(401).send({
            message: "unknown error"
        })

    } catch (error) {
        return res.status(500).json({
            status: 500,
            message: error.message,
        });
    }
};

exports.logout = async({ decoded }, res) => {
    try {
        const update = await models.user.update({ refresh_token: '' }, { where: { id: decoded.id } });
        if (update) {
            return res.status(200).send({
                message: "sucessfully logout",

            });
        }
        return res.status(400).send({
            message: "unknown error"
        })
    } catch (error) {
        return res.status(500).json({
            status: 500,
            message: error.message,
        });
    }
}

exports.refresh = async(req, res) => {
    try {
        const { token, id } = req.body;
        const check = auth.jwtToken.verifyToken(token);
        if (!check) {
            const user = await models.user.findByPk(id);
            if (user && user.refresh_token != null || user.refresh_token.length > 0) {
                const token = auth.jwtToken.createToken(user);
                if (user.refresh_token == 'blocked') {
                    return res.status(403).send({
                        message: "You been blocked due to violation of usage!🙅🏾‍♀️ ",

                    });
                }

                return res.status(200).send({
                    message: "welcome back to Pipoca 🍿 use the token to gain access!😄",
                    token,
                });
            }
            return res.status(401).send({
                message: "your are not sign in",

            });
        }
        return null;
    } catch (error) {
        return res.status(500).json({
            status: 500,
            message: error.message,
        });
    }
}

exports.forgot = async(req, res) => {


    try {

        const { email } = req.body;

        const user = await models.user.findOne({
            where: { email: email }
        });
        if (!user) {
            return res.status(400).send({ message: '📧Email Enviado! Verifique seu e-mail.' });
        }
        const { username } = user;

        const token = auth.jwtToken.passToken(user);
        const host = req.headers.host;
        const http = req.protocol;
        const logo = "/public/images/red.png";
        const link = `${http}://${host}/v1/auth/reset-password?token=${token}`;
        let transporter = nodemailer.createTransport(
            nodemailerSendgrid({
                apiKey: process.env.SEND_GRID
            })
        );

        ejs.renderFile(path.join(__dirname, '../../views', 'email.ejs'), { name: username, link: link, logo: logo, confirmation: false, title: 'Redefinição de senha' }, async function(err, data) {
            if (err) {
                return res.status(400).send({ message: `Tenta novamente erro no link: ${err}` });
            } else {
                let mailOptions = {

                    from: 'Ruben Sousa 😀 <coverxstories@gmail.com>',
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
                transporter.sendMail(mailOptions, function(err, data) {
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
exports.reset = async(req, res) => {
    try {


        const { token } = req.query;

        if (token) {
            return res.render('reset', { token: token, msg: '', title: 'Redefinição de senha' });
        }

        return res.status(401).send('401: Unauthorized 💩!');



    } catch (error) {
        return res.status(500).json({
            status: 500,
            message: error.message,
        });
    }
};
exports.send = async(req, res) => {
    try {


        const { password, confirmation, token } = req.body;

        const verify = auth.jwtToken.verifyPassToken(token);
        if (token && verify) {


            const user = await models.user.findOne({
                where: {
                    reset_password_token: token,
                    reset_password_expiration: {
                        [Op.gt]: Date.now()
                    }
                }
            });
            if (!user) {
                return res.render('reset', { msg: '422: token de redefinição de senha é inválido ou expirou 💩!', title: 'Redefinição de senha' })
            }


            if (user.refresh_token != 'blocked') {
                if (password === confirmation) {
                    const hash = auth.hashPassword(password);
                    const date = new Date(0);
                    const update = await models.user.update({ password: hash, reset_password_token: '', reset_password_expiration: date }, { where: { id: user.id } })
                    if (update) {
                        return res.render('reset', { msg: 'Sua senha foi atualizada com sucesso!\n De volta a pipocar 🥳', title: 'Redefinição de senha' })
                    }
                    return res.render('reset', { msg: 'Erro desconhecido', title: 'Redefinição de senha' })
                }
                return null;
            }


            return res.render('reset', { msg: 'You been blocked due to violation of usage!🙅🏾‍♀️', title: 'Redefinição de senha' })

        }



        return res.status(401).send('401: Unauthorized 💩!');

    } catch (error) {
        return res.status(500).json({
            status: 500,
            message: error.message,
        });
    }
};