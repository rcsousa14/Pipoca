const Sequelize = require('sequelize');
const models = require('../models');
require('dotenv').config();
exports.paginate = async(model, id, page, limit, search, order, attributes, include, group, vote) => {

    const offset = this.getOffset(page, limit);

    const { count, rows } = await model.findAndCountAll({
        distinct: true,
        order: order,
        limit: limit,
        offset: offset,
        where: search,
        group: group,
        attributes: attributes,
        include: include
    });

    var data = [];
    for (var row of rows) {


        if (vote == 'post') {
            // this gets the total of all comments a post has 

            const comments = await models.comment.findAll({
                where: { post_id: row.id },

                attributes: [
                    [Sequelize.cast(Sequelize.fn('COUNT', Sequelize.col('id')), 'INT'), 'total'],
                ]

            });
            // this gets the sum of all votes a post has
            const votes = await models.post_vote.findAll({

                where: { post_id: row.id },
                attributes: [
                    [Sequelize.cast(Sequelize.fn('SUM', Sequelize.col('voted')), 'INT'), 'total'],
                ]
            });
            // this gets if current user upvoted/downvoted and the value
            const vote = await models.post_vote.findOne({
                raw: true,
                where: { user_id: id, post_id: row.id },
                attributes: { exclude: ['user_id', 'post_id', 'createdAt', 'updatedAt', 'id'] }
            });
            const isVoted = vote ? true : false;

            data.push({
                "user_voted": isVoted,
                "user_vote": vote == null ? 0 : vote.voted,
                "post_comments_total": comments.total == null ? 0 : comments.total,
                "post_votes_total": votes == null ? 0 : votes.total,
                "post": row
            });

        }
        if (vote == 'comment') {
            // this gets the total of all sub_comments a comment has 
            const sub_comments = await models.comment.findAll({
                where: { comemnt_id: row.id },

                attributes: [
                    [Sequelize.cast(Sequelize.fn('COUNT', Sequelize.col('id')), 'INT'), 'total'],
                ]

            });
            // this gets the sum of all votes a comment has
            const votes = await models.comment_vote.findAll({

                where: { comment_id: row.id },
                attributes: [
                    [Sequelize.cast(Sequelize.fn('SUM', Sequelize.col('voted')), 'INT'), 'total'],
                ]
            });
            // this gets if current user upvoted/downvoted and the value
            const vote = await models.comment_vote.findOne({
                raw: true,
                where: { user_id: id, comment_id: row.id },
                attributes: { exclude: ['user_id', 'comment_id', 'createdAt', 'updatedAt', 'id'] }
            });
            const isVoted = vote ? true : false;

            data.push({
                "user_voted": isVoted,
                "user_vote": vote == null ? 0 : vote.voted,
                "comment_sub_comments_total": sub_comments.total == null ? 0 : sub_comments.total,
                "comments_votes_total": votes == null ? 0 : votes.total,
                "comment": row
            });

        }
        if (vote == 'sub') {
            // this gets the sum of all votes a comment has
            const votes = await models.sub_comment_vote.findAll({

                where: { sub_comment_id: row.id },
                attributes: [
                    [Sequelize.cast(Sequelize.fn('SUM', Sequelize.col('voted')), 'INT'), 'total'],
                ]
            });
            const vote = await models.sub_comment_vote.findOne({
                raw: true,
                where: { user_id: id, sub_comment_id: row.id },
                attributes: { exclude: ['user_id', 'comment_id', 'createdAt', 'updatedAt', 'id'] }
            });
            const isVoted = vote ? true : false;

            data.push({
                "user_voted": isVoted,
                "user_vote": vote == null ? 0 : vote.voted,
                "sub_comments_votes_total": votes == null ? 0 : votes.total,
                "sub_comment": row
            });

        }

    };



    return {

        previousPage: this.getPreviousPage(page),
        currentPage: page,
        nextPage: this.getNextPage(page, limit, count.length),
        total: count.length,
        limit: limit,
        data
    };
}
exports.admin = async(model, page, limit, attributes, include) => {
    const offset = this.getOffset(page, limit);
    const { count, rows } = await model.findAndCountAll({
        limit: limit,
        offset: offset,
        distinct: true,
        attributes: attributes,
        include: include
    });


    return {
        previousPage: this.getPreviousPage(page),
        currentPage: page,
        nextPage: this.getNextPage(page, limit, count.length),
        total: count.length,
        limit: limit,
        data: rows
    }
}
exports.getOffset = (page, limit) => {
    return (page * limit) - limit;
}

exports.getNextPage = (page, limit, total) => {
    if ((total / limit) > page) {
        return page + 1;
    }

    return null
}

exports.getPreviousPage = (page) => {
    if (page <= 1) {
        return null
    }
    return page - 1;
}