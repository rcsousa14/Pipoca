const isPorn = require('is-porn');

export default ({ body }, res, next) => {
    const { links } = body;

    if (!Array.isArray(links) || !links.length) {
        next();
    }
    for (var link of links) {

        isPorn(link, function(error, status) {
            if (!error) {
                return res.send({ message: status, link: link });
            }
            return res.send({ message: 'we good' });

        });
    }

}