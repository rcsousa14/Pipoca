

export default async (req, res, next) => {
    const { username, phone_number, fcm_token, bio } = req.body;

    const usernameRegex = /^(?!.*\.\.)(?!.*\.$)[^\W][\w.]{0,20}$/;

    const phoneRegex = /^[+]?(\d{1,3})?[\s.-]?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{3}$/;

    

    if (!username) {
        return res.status(400).send({ message: '😱 Nome de usuário é requerido!' });
    }
    if (username && username.length > 20) {
        return res.status(400).send({ message: '😱 Nome do usuário é muito grande!' });
    }
    if (!phone_number) {
        return res.status(400).send({ message: '📵 Telefone é requerido!' });
    }
    if (!usernameRegex.test(username)) {
        return res.status(400).send({ message: '🤷🏾‍♂️ Nome de usuário deve incluir alfanumérico, ponto (.) ou sublinhado (_)' });
    }
    if (bio && bio.length > 124) {
        return res.status(400).send({ message: '🛑 Apenas 124 carateres para o bio' });
    }
    if (!phoneRegex.test(phone_number)) {
        return res.status(400).send({ message: '📵 Digite o número de telefone correto' });
    }
    if (!fcm_token) {
        return res.status(500).send({ message: '❎ Token é requerido fale com o admin!' });
    }

    next();
};