import ApiError from "../errors/api_error";
export default async(req, res, next) => {
    const { content, longitude, latitude, links } = req.body;
    var nsfws = [
        "porn",
        "porno",
        "pornografia",
        "sex",
        "sexo",
        "xxx",
        "pornhub",
        "xvideos",
        "xhamster",
        "tube8",
        "redtube",
        "xnxx",
        "hclips",
        "spankbang",
        "adult",
        "slut",
        "bitch",
        "fuck",
        "foder",
        "porra",
        "pussy",
        "dick",
        "ass",
        "pila",
        "cona",
        "suicidio",
        "brazzers",
        "masturbation",
        "masturb",
        "teamSkeet",
        "mofos",
        "pureTaboo",
        "blacked",
        "jizz",
        "camsoda",
        "chaturbate",
        "anal",
        "anus",
        "puta",
        "punheta",
        "rabuda",
        "xuxuta",
        "xuxuado",
        "Siririca",
        "Testuda",
        "Tezao",
        "Tezuda",
        "Tezudo",
        "Xota",
        "Xochota",
        "Xoxota",
        "Xana",
        "Xaninha",
        "liveleaks"



    ];
    if (!content && links.length == 0) {
        next(ApiError.badRequestException('Bago é requerido!'));
        return;

    }
    if (content.length > 200) {
        next(ApiError.badRequestException('Bago deve ter menos de 200 caracteres.'));
        return;

    }
    if (!latitude || !longitude) {
        next(ApiError.badRequestException('Localização é obrigatório!'));
        return;

    }
    if (links.length > 0 && nsfws.some((nsfw) => links[0].includes(nsfw))) {
        next(ApiError.unauthorisedValidException("Desculpe, não pode postar conteúdo adulto."));
        return;

    }
    next();
}