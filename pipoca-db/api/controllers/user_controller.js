import ApiError from "../errors/api_error";
import CacheService from "../utils/cache";
const Sequelize = require("sequelize");
const { admin } = require("../utils/paginate");
const models = require("../models");
const ttl = 30;
const cache = new CacheService(ttl);

// for the admin need to see how many posts a user has etc etc
exports.index = async(req, res, next) => {
    try {
        const page = parseInt(req.query.page);
        const limit = 25;
        let attributes = { exclude: ["bio", "role_id"] };
        let include = [{
            model: models.role,
            as: "role",
            where: { role: "regular" },
            attributes: { exclude: ["createdAt", "updatedAt", "id"] },
        }, ];
        const model = models.user;
        const users = await admin(model, page, limit, attributes, include);

        return res
            .status(200)
            .send({ success: true, message: "here is all the users admin", users });
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};

exports.show = async({ decoded }, res, next) => {
    try {
        const result = cache.get(`user_single_${decoded.id}`);
        if (result) {
            return res.status(200).json(result);
        }

        if (decoded.id == null) {
            ApiError.badRequestException("Problema com a auth");
        }
        const user = await models.user.findOne({
            group: ["user.id", "posts.id", "comments.id", "sub_comments.id"],
            raw: true,

            where: {
                id: decoded.id,
            },
            distinct: true,
            attributes: [
                "id",
                "username",
                "email",
                "bio",
                "avatar",
                "birthday",
                "fcm_token",
                "createdAt", [
                    Sequelize.literal(
                        `(SELECT CAST(SUM(voted) AS INT)  fROM post_votes WHERE post_id = posts.id)`
                    ),
                    "posts_votes_total",
                ],
                [
                    Sequelize.literal(
                        `(SELECT CAST(SUM(voted) AS INT)  fROM comment_votes WHERE comment_id = comments.id)`
                    ),
                    "comments_votes_total",
                ],
                [
                    Sequelize.literal(
                        `(SELECT CAST(SUM(voted) AS INT)  fROM sub_comment_votes WHERE sub_comment_id = sub_comments.id)`
                    ),
                    "sub_comments_votes_total",
                ],
                [
                    Sequelize.literal(
                        `(SELECT CAST(COUNT(id) AS INT)  fROM posts WHERE user_id = ${decoded.id})`
                    ),
                    "user_posts_total",
                ],
                [
                    Sequelize.literal(
                        `(SELECT CAST(COUNT(id) AS INT)  fROM comments WHERE user_id = ${decoded.id})`
                    ),
                    "user_comments_total",
                ],
                [
                    Sequelize.literal(
                        `(SELECT CAST(COUNT(id) AS INT)  fROM sub_comments WHERE user_id = ${decoded.id})`
                    ),
                    "user_sub_comments_total",
                ],
            ],
            include: [{
                    model: models.post,
                    as: "posts",

                    attributes: [],
                    duplicating: false,
                    required: false,
                },
                {
                    model: models.comment,
                    as: "comments",
                    attributes: [],
                    duplicating: false,
                    required: false,
                },
                {
                    model: models.sub_comment,
                    as: "sub_comments",
                    attributes: [],
                    duplicating: false,
                    required: false,
                },
            ],
        });

        const data = {
            success: true,
            message: "Usuário foi encontrado",

            user: {
                id: user.id,
                username: user.username,
                email: user.email,
                bio: user.bio,
                avatar: user.avatar,
                birthday: user.birthday,
                fcm_token: user.fcm_token,
                created_at: user.createdAt,
                karma_total: 10 +
                    user.posts_votes_total +
                    user.comments_votes_total +
                    user.sub_comments_votes_total,
                interation_total: user.user_posts_total +
                    user.user_comments_total +
                    user.user_sub_comments_total,
                karma: {
                    posts_votes_total: user.posts_votes_total == null ? 0 : user.posts_votes_total,
                    comments_votes_total: user.comments_votes_total == null ? 0 : user.comments_votes_total,
                    sub_comments_votes_total: user.sub_comments_votes_total == null ?
                        0 : user.sub_comments_votes_total,
                },
                interation: {
                    user_posts_total: user.user_posts_total,
                    user_comments_total: user.user_comments_total,
                    user_sub_comments_total: user.user_sub_comments_total,
                },
            },
        };
        cache.set(`user_single_${decoded.id}`, data);

        return res.status(200).json(data);
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};

exports.destroy = async({ decoded }, res, next) => {
    try {
        await models.user.destroy({
            where: {
                id: decoded.id,
            },
        });
        cache.del(`user_single_${decoded.id}`);
        cache.del(`user_sub_comments_feed_${decoded.id}`);
        cache.del(`user_sub_comments_${decoded.id}`);
        cache.del(`user_sub_comment_${decoded.id}`);
        cache.del(`user_comments_feed_${decoded.id}`);
        cache.del(`user_comments_${decoded.id}`);
        cache.del(`user_comment_${decoded.id}`);
        cache.del(`user_posts_${decoded.id}`);
        cache.del(`user_post_${decoded.id}`);
        cache.del(`post_${decoded.id}`);
        return res
            .status(200)
            .send({ success: true, message: "Nós odiamos ver você ir. Volto logo!" });
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};

exports.update = async({ body, decoded }, res, next) => {
    try {

        const { username, avatar, birthday, bio, fcmToken, password } = body;
        await models.user.update({ password, username, avatar, birthday, bio, fcm_token: fcmToken }, {
            where: {
                id: decoded.id,
            },
        });
        cache.del(`user_single_${decoded.id}`);
        return res
            .status(200)
            .send({ success: true, message: "So sucesso! de volta a pipocar" });
    } catch (error) {
        next(
            ApiError.internalException("Não conseguiu se comunicar com o servidor")
        );
        return;
    }
};