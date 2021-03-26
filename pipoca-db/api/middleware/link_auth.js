import { getLinkPreview } from 'link-preview-js';
const isPorn = require('is-porn');

export default ({ body }, res, next) => {
    const { links } = body;
    let isStatus;
    let urlData = {};
    if (!Array.isArray(links) || !links.length) {
        next();
    }


    isPorn(links[0], function(error, status) {
        if (!error) return res.send(status)
        return res.send(error)
    });
    // getLinkPreview(links[0]).then((data) => urlData = data);







}