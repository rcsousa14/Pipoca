export default async(req, res, next) => {

    const { email, password, username, bio } = req.body;

    const emailRegex = /^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$/;

    const passRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;

    const usernameRegex = /^(?!.*\.\.)(?!.*\.$)[^\W][\w.]{0,20}$/;


    if (username && !usernameRegex.test(username)) {
        return res.status(400).send({ message: '🤷🏾‍♂️ Nome de usuário deve incluir alfanumérico, ponto (.) ou sublinhado (_)' });
    }
    if (username && username.length > 20) {
        return res.status(400).send({ message: '😱 Nome do usuário é muito grande!' });
    }
    if (email && !emailRegex.test(email)) {
        return res.status(400).send({ message: '📧 Digite o email correctamente' });
    }
    if (password && !passRegex.test(password)) {
        return res.status(400).send({ message: '🔓 Mínimo de oito caracteres, pelo menos uma letra e um número' });
    }
    if (bio && bio.length > 124) {
        return res.status(400).send({ message: '🛑 Apenas 124 carateres para o bio' });
    }

    next();
};