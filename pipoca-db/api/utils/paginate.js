import { getDistance } from 'geolib';
const Sequelize = require('sequelize');
const models = require('../models');
const cheerio = require('cheerio');
const axios = require('axios');
const Op = Sequelize.Op;

require('dotenv').config();

const scrapeMetaTags = async (url) => {
    const res = await axios.get(url);
    const html = res.data;
    const $ = cheerio.load(html);

    const getMetaTag = (name) =>
        $(`meta[name=${name}]`).attr('content') ||
        $(`meta[property="og:${name}"]`).attr('content') ||
        $(`meta[property="twitter:${name}"]`).attr('content')

    return {
        url,
        title: $('title').text(),
        description: getMetaTag('description'),
        image: getMetaTag('image'),
        video: getMetaTag('video'),
        site: getMetaTag('site_name'),
        

    }
}
exports.paginate = async (model, id, page, limit, search, order, attributes, include, group, lat, lng, filtro) => {

    const offset = this.getOffset(page, limit);

    const { count, rows } = await model.findAndCountAll({
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
            distance = getDistance({ latitude: lat, longitude: lng }, { latitude: row.coordinates.coordinates[1], longitude: row.coordinates.coordinates[0] });
        }


        let isNear;
        if (distance <= 950) isNear = true;
        if (distance > 950) isNear = false;

        let where;
        let model;

        if (filtro == 'post') {
            model = models.post_vote;

            where = {
                user_id: id,
                post_id: row.id,

            }
        }
        if (filtro == 'comment') {
            model = models.comment_vote;

            where = {
                user_id: id,
                comment_id: row.id
            }
        }
        if (filtro == 'sub') {
            model = models.sub_comment_vote;

            where = {
                user_id: id,
                subComment_id: row.id
            }
        }
        let linkInfo = {};
        if(row.links.length > 0){
         const { url } = row.links[0];
         linkInfo = await scrapeMetaTags(url);
        
        }
        //console.log(linkInfo);
        // this gets if current user upvoted/downvoted and the value
        const vote = await model.findOne({
            raw: true,
            where: where,

            attributes: { exclude: ['user_id', 'post_id', 'createdAt', 'updatedAt', 'id'] }
        });
        const isVoted = vote ? true : false;



        if (filtro == 'post') data.push({
            "user_voted": isVoted,
            "user_vote": vote == null ? 0 : vote.voted,
            "user_isNear": isNear,
            "post": {
                "id": row.id,
                "content": row.content,
                "links": linkInfo,
                "votes_total": row.votes_total == null ? 0 : row.votes_total,
                "comments_total": row.comments_total,
                "flags": row.flags,
                "is_flagged": row.is_flagged,
                "is_deleted": row.is_deleted,
                "created_at": row.createdAt,
                "creator": row.creator
            }
        });
        if (filtro == 'comment') data.push({
            "user_voted": isVoted,
            "user_vote": vote == null ? 0 : vote.voted,
            "user_isNear": isNear,
            "comment": {
                "id": row.id,
                "content": row.content,
                "links": linkInfo,
                "votes_total": row.votes_total == null ? 0 : row.votes_total,
                "sub_comments_total": row.comments_total,
                "flags": row.flags,
                "is_flagged": row.is_flagged,
                "is_deleted": row.is_deleted,
                "created_at": row.createdAt,
                "creator": row.creator
            }
        });
        if (filtro == 'sub') data.push({
            "user_voted": isVoted,
            "user_vote": vote == null ? 0 : vote.voted,
            "user_isNear": isNear,
            "sub_comment": {
                "id": row.id,
                "content": row.content,
                "links": linkInfo,
                "votes_total": row.votes_total == null ? 0 : row.votes_total,
                "flags": row.flags,
                "is_flagged": row.is_flagged,
                "is_deleted": row.is_deleted,
                "created_at": row.createdAt,
                "creator": row.creator
            }
        });



    };



    return {

        previousPage: this.getPreviousPage(page),
        currentPage: page,
        nextPage: this.getNextPage(page, limit, count.length),
        total: count.length,
        limit: limit,
        data: data
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