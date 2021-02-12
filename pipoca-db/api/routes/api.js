import { Router } from 'express';
import authMiddleware from '../middleware/auth';
import authorizeMiddleware from '../middleware/authorize';
import postauthMiddleware from '../middleware/post_auth';
import adminMiddleware from '../middleware/admin_auth';
import commentAuthMiddleware from '../middleware/comment_auth';
const user = require('../controllers/user_controller');
const auth = require('../controllers/auth_controller');
const role = require('../controllers/role_controller');
const post_vote = require('../controllers/post_vote_controller');
const comment_vote = require('../controllers/comment_vote_controller');
const sub_comment_vote = require('../controllers/sub_comment_vote');
const post = require('../controllers/post_controller');
const user_posts = require('../controllers/user_post_controller');
const user_comments = require('../controllers/user_comment_controller');
const user_sub_comments = require('../controllers/user_sub_comment_controller');
const router = Router();


/**
 * ☑️ endpoint is ready to go
 * ❎ endpoint needs a test or there is a note to work on
 */

router.get('/v1', (req, res) => {
    res.send({
        message: "🎊welcome to pipoca api🍿!"
    })
})


//auth routes - this route gives you the access key
router.post('/v1/auth/signup', authMiddleware, auth.signup); //☑️
router.post('/v1/auth/login', auth.login); //☑️


//roles routes - this route only for admins set user roles for the
router.post('/v1/admin/roles', authorizeMiddleware, adminMiddleware, role.store); //☑️
router.delete('/v1/admin/roles/:id', authorizeMiddleware, adminMiddleware, role.destroy); //☑️
router.get('/v1/admin/roles', authorizeMiddleware, adminMiddleware, role.index); //☑️

//user routes
router.get('/v1/users', authorizeMiddleware, user.show); //☑️
router.get('/v1/admin/users', authorizeMiddleware, adminMiddleware, user.index); //☑️
router.delete('/v1/users', authorizeMiddleware, user.destroy); //☑️
router.patch('/v1/users', authorizeMiddleware, user.update); //☑️

//votes routes
router.post('/v1/post/votes', authorizeMiddleware, post_vote.store); //☑️
router.post('/v1/comment/votes', authorizeMiddleware, comment_vote.store); //☑️
router.post('/v1/sub_comment/votes', authorizeMiddleware, sub_comment_vote.store); //☑️

//post routes
router.get('/v1/feed', authorizeMiddleware, post.index); //❎ this will be a search with where like
router.get('/v1/posts/:id', authorizeMiddleware, post.show); //❎ check if it works might need to call the totals separte

// user posts routes
router.post('/v1/posts', authorizeMiddleware, postauthMiddleware, user_posts.store); //☑️
router.get('/v1/user/feed', authorizeMiddleware, user_posts.index); //❎ need to figure out how you will do the query probably sort the final list
router.get('/v1/posts', authorizeMiddleware, user_posts.show); //❎ need to be tested
router.delete('/v1/posts/:id', authorizeMiddleware, user_posts.destroy); //☑️

// user comments routes
router.post('/v1/:post_id/comments', authorizeMiddleware, commentAuthMiddleware, user_comments.store); //☑️need to be tested
router.get('/v1/:post_id/comments', authorizeMiddleware, user_comments.index); //☑️ need to be tested
router.get('/v1/comments', authorizeMiddleware, user_comments.show); //❎ need to be tested
router.delete('/v1/comments/:id', authorizeMiddleware, user_comments.destroy); //❎ need to be tested

// user sub_comments routes
router.post('/v1/:comment_id/sub_comments', authorizeMiddleware, commentAuthMiddleware, user_sub_comments.store); //❎ need to be tested
router.get('/v1/:comment_id/sub_comments', authorizeMiddleware, user_sub_comments.index); //❎ need to be tested
router.get('/v1/sub_comments', authorizeMiddleware, user_sub_comments.show); //❎ need to be tested
router.delete('/v1/sub_comments/:id', authorizeMiddleware, user_sub_comments.destroy); //❎ need to be tested


/**
 * 
 * need to delete tags
 * need to figure out the right way to delete a comment maybe soft 
 * delete need to add isDeleted to comments and subcomments need to add the isnear on all posts
 */

export default router;