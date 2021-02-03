const models = require('../models');
const Op =require('sequelize').Op;
export default async (req, res, next) => {
    const { username, password, phone, fcm_token , name } = req.body; 

    const usernameRegex = /^(?!.*\.\.)(?!.*\.$)[^\W][\w.]{0,29}$/;
    const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;
    const phoneRegex = /^[+]?(\d{1,3})?[\s.-]?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{3}$/;

    const checkUser = await models.user.findOne(
        {where: {
            [Op.or]: [{username: username},{phone: phone}]
        }
    });

    if(!name){
        return res.status(400).send({message: '😥 Nome é requerido!'});
    }
    if(!username) {
        return res.status(400).send({ message: '😱 Nome de usuário é requerido!'});
    }
    if(!usernameRegex.test(username)){
        return res.status(400).send({ message: '🤷🏾‍♂️ Nome de usuário deve incluir alfanumérico, ponto (.) ou sublinhado (_)'});
    }
    if(!password){
        return res.status(400).send({ message: '😱 Senha  é requerido!'});
    }
    if(!passwordRegex.test(password)){
        return res.status(400).send({ message: '🤷🏾‍♂️ Senha deve conter no mínimo oito caracteres, pelo menos uma letra e um número'});
    }
    if(!phoneRegex.test(phone)){
        return res.status(400).send({ message: '📵 Digite o número de telefone correto'});
    }
    if(!fcm_token){
        return res.status(500).send({ message: '❎ Token é requerido fale com o admin!'});
    }
    if(checkUser){
        return res.status(409).send({ message: '😱 Este usuário já existe! Verifica seu número de telefone ou username'});
    }
     next();
};