import { Router } from 'express';
import rateLimit from 'express-rate-limit';
import slowDown from 'express-slow-down';
import authMiddleware from '../middleware/auth';
import authorizeMiddleware from '../middleware/authorize';
import postauthMiddleware from '../middleware/post_auth';
import adminMiddleware from '../middleware/admin_auth';
import voteMiddleware from '../middleware/vote_auth';
import linkMiddleware from '../middleware/link_auth';

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

const limiter = rateLimit({
    windowMs: 30 * 1000,
    max: 5
});

const speedLimiter = slowDown({
    windowMs: 30 * 1000,
    delayAfter: 1,
    delayMs: 450,
});


router.get('/v1', (req, res) => {
    res.render('api');
})




//auth routes - this route gives you the access key

router.post('/v1/auth/signup', limiter, speedLimiter, authMiddleware, auth.signup); //need to check email... send email
router.get('/v1/auth/activate-account/:token', limiter, speedLimiter, auth.confirmation);
router.post('/v1/auth/login', limiter, speedLimiter, authMiddleware, auth.login); //☑️
router.post('/v1/auth/social', limiter, speedLimiter, authMiddleware, auth.social); //☑️
router.post('/v1/auth/refresh-token', limiter, speedLimiter, auth.refresh);
router.patch('/v1/auth/logout', limiter, speedLimiter, authorizeMiddleware, auth.logout);
router.post('/v1/auth/forgot-password', limiter, speedLimiter, auth.forgot);
router.get('/v1/auth/reset-password', limiter, speedLimiter, auth.reset); //needs a middleware to check if the token query exists
router.post('/v1/auth/reset-password', limiter, speedLimiter, auth.send);

//roles routes - this route only for admins set user roles for the
router.post('/v1/admin/roles', limiter, speedLimiter, role.store); //☑️
router.delete('/v1/admin/roles/:id', authorizeMiddleware, adminMiddleware, role.destroy); //☑️
router.get('/v1/admin/roles', speedLimiter, authorizeMiddleware, adminMiddleware, role.index); //☑️

//user routes
router.get('/v1/users', speedLimiter, authorizeMiddleware, user.show); //☑️❎ cache data with redis
router.get('/v1/admin/users', speedLimiter, authorizeMiddleware, adminMiddleware, user.index); //☑️
router.delete('/v1/users', authorizeMiddleware, user.destroy); //☑️
router.patch('/v1/users', limiter, speedLimiter, authorizeMiddleware, authMiddleware, user.update); //☑️

//votes routes
router.post('/v1/post/votes', limiter, authorizeMiddleware, voteMiddleware, post_vote.store); //☑️
router.post('/v1/comment/votes', limiter, authorizeMiddleware, voteMiddleware, comment_vote.store); //☑️
router.post('/v1/sub_comment/votes', limiter, authorizeMiddleware, voteMiddleware, sub_comment_vote.store); //☑️

//post routes
//router.get('/v1/feed', speedLimiter, authorizeMiddleware, post.index); //❎ this will be a search with where like need to think about it more
router.get('/v1/posts/:id', speedLimiter, authorizeMiddleware, post.show); //☑️❎ cache data with redis
router.get('/v1/link-info', authorizeMiddleware, user_posts.link);
// user posts routes
router.post('/v1/posts', limiter, speedLimiter, authorizeMiddleware, postauthMiddleware, linkMiddleware, user_posts.store); //☑️❎ cache data and check if is the samething as before for spam 
router.get('/v1/user/feed', limiter, speedLimiter, authorizeMiddleware, user_posts.index); //☑️❎ checkout the pipocar filter maybe last 3 days & cache data with redis
router.get('/v1/posts', speedLimiter, authorizeMiddleware, user_posts.show); //☑️ ❎ cache data with redis
router.patch('/v1/posts/:id', limiter, speedLimiter, speedLimiter, authorizeMiddleware, user_posts.soft); //☑️

// user comments routes
router.post('/v1/:post_id/comments', limiter, speedLimiter, authorizeMiddleware, postauthMiddleware, user_comments.store); //☑️❎ cache data and check if is the samething as before for spam

router.get('/v1/:post_id/comments', speedLimiter, authorizeMiddleware, user_comments.index); //☑️❎ cache data with redis
router.get('/v1/comments', speedLimiter, authorizeMiddleware, user_comments.show); //☑️ ❎ cache data with redis
router.patch('/v1/comments/:id', limiter, speedLimiter, authorizeMiddleware, user_comments.soft); //☑️ need to be tested

// user sub_comments routes
router.post('/v1/:comment_id/sub_comments', limiter, speedLimiter, authorizeMiddleware, postauthMiddleware, user_sub_comments.store); //☑️❎ cache data and check if is the samething as before for spam
router.get('/v1/:comment_id/sub_comments', speedLimiter, authorizeMiddleware, user_sub_comments.index); //☑️❎ cache data with redis
router.get('/v1/sub_comments', speedLimiter, authorizeMiddleware, user_sub_comments.show); //☑️❎ cache data with redis
router.patch('/v1/sub_comments/:id', limiter, speedLimiter, authorizeMiddleware, user_sub_comments.soft); //☑️ need to be tested


/**
 * dont forget to cache the authorizeMiddleware
 */

export default router;