import { getLinkPreview } from 'link-preview-js';


export default ({ body }, res, next) => {
    const { links } = body;

    let urlData = {};
    if (!Array.isArray(links) || !links.length) {
        next();
    }



    getLinkPreview(links[0]).then((data) => urlData = data);



    return res.send(urlData);



}