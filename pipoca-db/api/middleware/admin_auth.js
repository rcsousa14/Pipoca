import models from '../models';


export default ({ decoded }, res, next)=> {
    // this checks if the user calling the enpoint is an admin
    const admin =  models.user.findOne({
        where: { id: decoded.id },
        include: [{
            model: models.role,
            as: 'role',
            where: { role: "admin" }
        }]
    });
    if (!admin) {
        return res.status(401).send('401: Unauthorized 💩!');
    }
    next();
}