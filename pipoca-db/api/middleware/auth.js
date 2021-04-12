import ApiError from "../errors/api_error";

export default async(req, res, next) => {

    const { email, password, username, bio } = req.body;

    const emailRegex = /^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$/;

    const passRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;

    const usernameRegex = /^(?!.*\.\.)(?!.*\.$)[^\W][\w.]{0,20}$/;


    if (username && !usernameRegex.test(username)) {
        next(ApiError.badRequestException('Nome de usuário deve incluir alfanumérico, ponto (.) ou sublinhado (_)'));
        return;


    }
    if (username && username.length > 20) {
        next(ApiError.badRequestException('Nome do usuário é muito grande!'));
        return;


    }
    if (email && !emailRegex.test(email)) {
        next(ApiError.badRequestException('Digite o email correctamente'));
        return;

    }

    if (password && !passRegex.test(password)) {
        next(ApiError.badRequestException('Mínimo de oito caracteres, pelo menos uma letra e um número'));
        return;

    }
    if (bio && bio.length > 124) {
        next(ApiError.badRequestException('Apenas 124 carateres para o bio'));
        return;

    }

    next();
};