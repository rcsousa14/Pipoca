

export default ({ body }, res, next) => {
    const { links } = body;

    if (!Array.isArray(links) || !links.length) {
        next();
    }

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

    if (nsfws.some((nsfw) => links[0].includes(nsfw))) {
        return res.status(403).send({
            message: "Desculpe, não pode postar conteúdo adulto",

        })
    }
   
    next();

};