class ApiError {
    constructor({ code, message }) {
        this.code = code;
        this.message = message;
    }

    static badRequestException(msg) {
        return new ApiError({
            code: 400,
            message: msg,
        });
    }
    static internalException(msg) {
            return new ApiError({
                code: 500,
                message: msg,
            });
        }
        //  this is is when credential are not valid
    static unauthorisedInvalidException(msg) {
        return new ApiError({
            code: 401,
            message: msg,
        });
    }
    static unauthorisedValidException(msg) {
        return new ApiError({
            code: 403,
            message: msg,
        });
    }
    static NotFoundException(msg) {
        return new ApiError({
            code: 404,
            message: msg,
        });

    }
}

module.exports = ApiError;