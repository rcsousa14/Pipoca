import { getLinkPreview } from 'link-preview-js';


export default ({ body }, res, next) => {
    const { links } = body;

    let urlData = {};
    if (!Array.isArray(links) || !links.length) {
        next();
    }



    urlData = getLinkPreview(links[0]);



    return res.send(urlData);



}