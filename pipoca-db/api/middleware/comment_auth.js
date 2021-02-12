export default async (req, res, next) => {
    const { content } = req.body;
    if(!content){
        return res.status(400).send({message: '✍🏾 bago é requerido!'});
    }
    if(content.length > 200){
        res.status(400).send({ message: '😱 erreh mano apenas 200 carateres 🙄'});
    }
   
    next();
}