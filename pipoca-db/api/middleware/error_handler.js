import ApiError from "../errors/api_error";

export default (err, req, res, next) => {
    if (err instanceof ApiError) {
        res.status(err.code).json({ success: false, message: err.message });
        return;
    }
    res.status(500).json({ success: false, message: "Algo deu errado" });
};