

const models = require('../models');
const auth = require('../utils');

const Op = require('sequelize').Op;




exports.signup = async (req, res) => {

    try {

        const { username, phone_number, phone_carrier, birthday, avatar, bio, fcm_token } = req.body;

        const checkname = await models.user.findOne({
            where: {
                [Op.or]: [
                    { username: username },
                    { phone_number: phone_number }
                ]
            }
        });
        if (checkname) {
            if (checkname.username === username) {
                return res.status(409).send({ message: 'O nome de usuário já existe' });
            }
            if (checkname.phone_number === phone_number) {
                return res.status(409).send({ message: 'O número de telefone já existe' });

            }

        }
        const { id } = await models.role.findOne({ where: { role: 'admin' } })
        const newUser = await models.user.create({ username, phone_number, phone_carrier, birthday, avatar, bio, fcm_token, role_id: id });
        const token = auth.jwtToken.createToken(newUser);

        return res.status(201).send({ message: 'welcome to Pipoca 🍿 use the token to gain access!😄', token });



    } catch (error) {

        return res.status(500).json({
            status: 500,
            message: error.message
        });
    }

};

exports.login = async (req, res) => {

    try {

        const { phone_number } = req.body;

        const checkUser = await models.user.findOne(
            {
                where:
                    { phone_number: phone_number }

            });
        if (!checkUser) {
            return res.status(400).send({ message: 'usuario nao existe!' });
        }

        const token = auth.jwtToken.createToken(checkUser);
        return res.status(200).send({ message: 'welcome back to Pipoca 🍿 use the token to gain access!😄', token });

    } catch (error) {

        return res.status(500).json({
            status: 500,
            message: error.message
        });
    }

};






