export default async (req, res, next) => {
    const { voted } = req.body;
    const voteRegex = /^\-?[1]$/;

    if(!voteRegex.test(voted)){
        return res.status(500).send({error: 'something is wrong with the voting system'});
    }
    next();
}