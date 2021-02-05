import models from '../models';

export default ({ body, decoded }, res, next) => {
    try {
        const { isPoint } = body; 
        const point = models.point.create({user_id: decoded.id, isPoint});
        next();
    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
}

// exports.store = async({body, decoded}, res, next) => {
//     try {
//         const { isPoint } = body; 
//         const point = models.point.create({user_id: decoded.id, isPoint});
//         next()
//     }catch (error) {
//         return res.status(500).json({
//             error: error.message
//         });
//     }
// }