import { Router } from 'express';
import authMiddleware from '../middleware/auth';
import authorizeMiddleware from '../middleware/authorize';
import postauthMiddleware from '../middleware/post_auth';
import adminMiddleware from '../middleware/admin_auth';
const user = require('../controllers/user_controller');
const auth = require('../controllers/auth_controller');
const role = require('../controllers/role_controller');
const post_vote = require('../controllers/post_vote_controller');
const comment_vote = require('../controllers/comment_vote_controller');
const sub_comment_vote = require('../controllers/sub_comment_vote');
const post = require('../controllers/post_controller');
const user_posts = require('../controllers/user_post_controller');
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
router.get('/v1/users', authorizeMiddleware, user.show); //☑️
router.get('/v1/admin/users', authorizeMiddleware, adminMiddleware, user.index); //☑️
router.delete('/v1/users', authorizeMiddleware, user.destroy); //☑️
router.patch('/v1/users', authorizeMiddleware, user.update);//☑️

//votes routes
router.post('/v1/post/votes', authorizeMiddleware, post_vote.store);//☑️
router.post('/v1/comment/votes', authorizeMiddleware, comment_vote.store);//☑️
router.post('/v1/sub_comment/votes', authorizeMiddleware, sub_comment_vote.store);//☑️

//post routes
router.get('/v1/feed', authorizeMiddleware, post.index); //❎ figure out limit sorting and the isnear
router.get('/v1/posts/:id', authorizeMiddleware, post.show); //☑️

// user posts routes
router.post('/v1/user/posts', authorizeMiddleware, postauthMiddleware, user_posts.store); //☑️❎ user upvote
router.get('/v1/user/feed', authorizeMiddleware, user_posts.index); //❎ figure out limit sorting user upvote
router.get('/v1/user/posts', authorizeMiddleware, user_posts.show);//☑️ need to filter it 
router.delete('/v1/user/posts/:id', authorizeMiddleware, user_posts.destroy); //☑️
/**
 * need the comment and comment_vote route
 * need the sub_comment and sub_comment_voute route
 * need to figure out the right way to delete a comment maybe soft delete
 */

export default router; 