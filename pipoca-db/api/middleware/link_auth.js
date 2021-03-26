import { getLinkPreview } from 'link-preview-js';


export default ({ body }, res, next) => {
    const { links } = body;


    if (!Array.isArray(links) || !links.length) {
        next();
    }



    getLinkPreview(links[0]).then((data) => res.send(data));







}