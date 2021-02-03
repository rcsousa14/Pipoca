

const models = require('../models');
const auth = require('../utils');

const Op =require('sequelize').Op;




    exports.signup = async (req, res) => {
        
        try {
            //TODO: sanitize the shit out of everything
            const { username, name, password, phone, gender, birthday, picture, fcm_token } = req.body;
           
            const hash = auth.hashPassword(password);
            
            const newUser = await models.user.create({username, name, password: hash, phone, gender, birthday, picture, fcm_token});
            const token = auth.jwtToken.createToken(newUser);
            
            return res.status(201).send({    message: 'welcome to Pipoca 🍿 use the token to gain access!😄', token });
        } catch (error) {
            
            return res.status(500).json({
                message: error.message
             });
        }

    };

    exports.login = async (req, res) =>{
        try {
           const {username, password} = req.body;
           const newUser = await models.user.findOne(
            {where: {username: username}
        });
        if(newUser && auth.comparePassword(password, newUser.password)){
            const token = auth.jwtToken.createToken(newUser);
            return res.status(200).send({ message: 'welcome back to Pipoca 🍿 use the token to gain access!😄', token });
        }
        return res.status(400).send({ message: 'verifique se nome de usuário/telefone e senha estão corretos' });
        } catch (error) {
            return res.status(500).json({
                message: error.message
             });
        }
    };
    // still need to know how the phone login works
    exports.loginPhone = async (req, res) =>{
        try {
           const {phone, password} = req.body;
           const newUser = await models.user.findOne(
            {where: {phone: phone}
        });
        if(newUser && auth.comparePassword(password, newUser.password)){
            const token = auth.jwtToken.createToken(newUser);
            return res.status(200).send({ message: 'welcome back to Pipoca 🍿 use the token to gain access!😄', token });
        }
        return res.status(400).send({ message: 'verifique se nome de usuário/telefone e senha estão corretos' });
        } catch (error) {
            return res.status(500).json({
                message: error.message
             });
        }
    }




