import ApiError from "../errors/api_error";
import models from "../models";

export default ({ decoded }, res, next) => {
    // this checks if the user calling the enpoint is an admin
    const admin = models.user.findOne({
        where: { id: decoded.id },
        include: [{
            model: models.role,
            as: "role",
            where: { role: "admin" },
        }, ],
    });
    if (!admin) {
        next(ApiError.unauthorisedInvalidException("desautorizado : 💩"));
        return;
    }
    next();
};