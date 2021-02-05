import { Router } from 'express';
import authMiddleware from '../middleware/auth';
import authorizeMiddleware from '../middleware/authorize';
const user = require('../controllers/user_controller');
const auth = require('../controllers/auth_controller');
const role = require('../controllers/role_controller');
const router = Router();

//routes


router.get('/v1', (req, res)=> {
    res.send({
        message: "🎊welcome to pipoca api🍿!"
    })
})

//auth routes
router.post('/v1/auth/signup', authMiddleware, auth.signup);
router.post('/v1/auth/login', auth.login);

//roles routes
router.post('/v1/admin/roles', authorizeMiddleware, role.store );
router.delete('/v1/admin/roles/:id', authorizeMiddleware, role.destroy );
router.get('/v1/admin/roles', authorizeMiddleware, role.index );

//user routes
router.get('/v1/users', authorizeMiddleware, user.show);
router.get('/v1/admin/users', authorizeMiddleware, user.index);
router.delete('/v1/users', authorizeMiddleware, user.delete);
router.put('/v1/users', authorizeMiddleware, user.update);

export default router; 