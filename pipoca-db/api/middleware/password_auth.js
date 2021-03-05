const { body, validationResult} = require('express-validator');

exports.validatePassword = [
    body('password')
    .isEmpty()
    .withMessage('🔓 A senha não pode estar vazia!')
    .matches(/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/, 'i')
    .withMessage('🔓 Mínimo de oito caracteres, pelo menos uma letra e um número'),
    (req, res, next) => {
        const errors = validationResult(req);
        if(!errors.isEmpty()){
             return res.render('reset', { msg: errors.array() })
        }
        next();
    }
]