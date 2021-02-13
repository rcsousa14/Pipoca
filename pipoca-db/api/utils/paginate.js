import { getDistance } from 'geolib';
const Sequelize = require('sequelize');
const models = require('../models');

require('dotenv').config();
exports.paginate = async (model, id, page, limit, search, order, attributes, include, group, vote, lat, lng) => {

    const offset = this.getOffset(page, limit);

    const { count, rows } = await model.findAndCountAll({
        distinct: true,
        order: order,
        limit: limit,
        offset: offset,
        where: search,
        group: group,
        attributes: attributes,
        include: include,

    });

    var data = [];
    const newRows = rows.map(function (row) {
        return row.toJSON()
    });
    for (var row of newRows) {
        let distance;
        if (lat && lng) {
            distance = getDistance(
                { latitude: lat, longitude: lng },
                { latitude: row.coordinates.coordinates[1], longitude: row.coordinates.coordinates[0] }
            );
        }


        let isNear;
        if (distance <= 950) isNear = true;
        if (distance > 950) isNear = false;

        if (vote == 'post') {
            // this gets the total of all comments a post has 

            const rawComments = await models.comment.findAll({
                where: { post_id: row.id },

                attributes: [
                    [Sequelize.cast(Sequelize.fn('COUNT', Sequelize.col('id')), 'INT'), 'total'],
                ]

            });

            // this gets if current user upvoted/downvoted and the value
            const vote = await models.post_vote.findOne({
                raw: true,
                where: { user_id: id, post_id: row.id },
                attributes: { exclude: ['user_id', 'post_id', 'createdAt', 'updatedAt', 'id'] }
            });
            const isVoted = vote ? true : false;
            const comments = rawComments.map(function (comment) {
                return comment.toJSON()
            });


            data.push({
                "user_voted": isVoted,
                "user_vote": vote == null ? 0 : vote.voted,
                "user_isNear": isNear,
                "post": {
                    "id": row.id,
                    "content": row.content,
                    "links": row.links,
                    "comments_total": comments[0].total,
                    "votes_total": row.votes_total == null ? 0 : row.votes_total,
                    "flags": row.flags,
                    "is_flagged": row.is_flagged,
                    "is_deleted": row.is_deleted,
                    "createdAt": row.createdAt,
                    "creator": row.creator
                }
            });

        }
        if (vote == 'comment') {
            // this gets the total of all sub_comments a comment has 
            const rawComments = await models.comment.findAll({
                where: { comemnt_id: row.id },

                attributes: [
                    [Sequelize.cast(Sequelize.fn('COUNT', Sequelize.col('id')), 'INT'), 'total'],
                ]

            });
            
            // this gets if current user upvoted/downvoted and the value
            const vote = await models.comment_vote.findOne({
                raw: true,
                where: { user_id: id, comment_id: row.id },
                attributes: { exclude: ['user_id', 'comment_id', 'createdAt', 'updatedAt', 'id'] }
            });
            const isVoted = vote ? true : false;
            const sub_comments = rawComments.map(function (comment) {
                return comment.toJSON()
            });

            data.push({
                "user_voted": isVoted,
                "user_vote": vote == null ? 0 : vote.voted,
                "user_isNear": isNear,
                "comment": {
                    "id": row.id,
                    "content": row.content,
                    "links": row.links,
                    "sub_comments_total": sub_comments[0].total,
                    "votes_total":  row.votes_total == null ? 0 : row.votes_total,
                    "flags": row.flags,
                    "is_flagged": row.is_flagged,
                    "is_deleted": row.is_deleted,
                    "createdAt": row.createdAt,
                    "creator": row.creator
                }
            });

        }
        if (vote == 'sub') {
            
            const vote = await models.sub_comment_vote.findOne({
                raw: true,
                where: { user_id: id, sub_comment_id: row.id },
                attributes: { exclude: ['user_id', 'comment_id', 'createdAt', 'updatedAt', 'id'] }
            });
            const isVoted = vote ? true : false;

            data.push({
                "user_voted": isVoted,
                "user_vote": vote == null ? 0 : vote.voted,
                "user_isNear": isNear,
                "sub_comment": {
                    "id": row.id,
                    "content": row.content,
                    "links": row.links,
                    "votes_total": row.votes_total == null ? 0 : row.votes_total,
                    "flags": row.flags,
                    "is_flagged": row.is_flagged,
                    "is_deleted": row.is_deleted,
                    "createdAt": row.createdAt,
                    "creator": row.creator
                }
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
exports.admin = async (model, page, limit, attributes, include) => {
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