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
    if (!content) {
        return res.status(400).send({ message: '✍🏾 bago é requerido!' });
    }
    if (content.length > 200) {
        res.status(400).send({ message: '😱 erreh mano apenas 200 carateres 🙄' });
    }
    if (!latitude || !longitude) {
        res.status(400).send({ message: '🗺️ Localização é obrigatório!' })
    }
    if (links.length > 0 && nsfws.some((nsfw) => links[0].includes(nsfw))) {
        res.status(400).send({
            message: "Desculpe, não pode postar conteúdo adulto",

        })
    }
    next();
}