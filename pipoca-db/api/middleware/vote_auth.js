import ApiError from "../errors/api_error";
export default async(req, res, next) => {
    const { voted } = req.body;
    const voteRegex = /^\-?[1]$/;

    if (!voteRegex.test(voted)) {
        next(ApiError.internalException('Algo está errado com o sistema de pontos '));
        return;

    }
    next();
}