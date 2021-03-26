import { getLinkPreview } from 'link-preview-js';

export default async({ body }, res, next) => {
    const { links } = body;

    if (!Array.isArray(links) || !links.length) {
        next();
    }

    var data = await getLinkPreview(links[0])

    if (data) {
        return res.send({ data: data });
    }


}