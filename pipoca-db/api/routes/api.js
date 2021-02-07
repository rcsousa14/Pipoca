import { Router } from 'express';
import authMiddleware from '../middleware/auth';
import authorizeMiddleware from '../middleware/authorize';
import postauthMiddleware from '../middleware/post_auth';
import adminMiddleware from '../middleware/admin_auth';
const user = require('../controllers/user_controller');
const auth = require('../controllers/auth_controller');
const role = require('../controllers/role_controller');
const vote = require('../controllers/post_vote_controller');
const post = require('../controllers/post_controller');
const router = Router();


/**
 * ☑️ endpoint is ready to go
 * ❎ endpoint needs a test or there is a note to work on
 */

router.get('/v1', (req, res)=> {
    res.send({
        message: "🎊welcome to pipoca api🍿!"
    })
})


//auth routes - this route gives you the access key
router.post('/v1/auth/signup', authMiddleware, auth.signup); //☑️
router.post('/v1/auth/login',  auth.login); //☑️


//roles routes - this route only for admins set user roles for the
router.post('/v1/admin/roles', authorizeMiddleware, adminMiddleware, role.store ); //☑️
router.delete('/v1/admin/roles/:id', authorizeMiddleware, adminMiddleware, role.destroy ); //☑️
router.get('/v1/admin/roles', authorizeMiddleware, adminMiddleware, role.index ); //☑️

//user routes
router.get('/v1/users', authorizeMiddleware, user.show); //❎
router.get('/v1/admin/users', authorizeMiddleware, adminMiddleware, user.index); //☑️
router.delete('/v1/users', authorizeMiddleware, user.destroy); //❎
router.put('/v1/users', authorizeMiddleware, user.update);//❎

//votes routes
router.post('/v1/votes', authorizeMiddleware, vote.store);//❎☑️ works but i have notes for better implementation

//post roures
router.post('/v1/posts', authorizeMiddleware, postauthMiddleware, post.store); //☑️
router.get('/v1/posts', authorizeMiddleware, post.index); //❎
router.get('/v1/feed', authorizeMiddleware, post.all); //❎
router.get('/v1/posts/:id', authorizeMiddleware, post.show); //☑️
router.delete('/v1/posts/:id', authorizeMiddleware, post.destroy); //☑️

/**
 * need the comment and comment_vote route
 * need the sub_comment and sub_comment_voute route
 * need to figure out the right way to delete a comment maybe soft delete
 */

export default router; 