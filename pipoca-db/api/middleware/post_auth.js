

export default async (req, res, next) => {
    const {post_text, longitude, latitude} = req.body;
    if(!post_text){
        return res.status(400).send({message: '✍🏾 bago é requerido!'});
    }
    if(post_text.length > 200){
        res.status(400).send({ message: '😱 erreh mano apenas 200 carateres 🙄'});
    }
    if(!latitude || !longitude){
        res.status(400).send({ message: '🗺️ Localização é obrigatório!'})
    }
    next();
}