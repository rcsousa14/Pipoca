import { getLinkPreview } from 'link-preview-js';

export default ({ body }, res, next) => {
    const { links } = body;

    if (!Array.isArray(links) || !links.length) {
        next();
    }

    var data = getLinkPreview(links[0]);

    if (data) {
        res.send(data);
    }


}