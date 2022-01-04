/**
 * @api {get} /api/v1/staff/emojis/:pack_id Get emojis icon list for a package
 * @apiPermission yes
 * @apiName GetEmojisIconList
 * @apiGroup Chat APIs
 *
 * @apiHeader {String} Authorization store access_token value
 * @apiHeaderExample {Header} Header-Example
 *   "Authorization": "Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz"
 * @apiParam {Number} pack_id id of line emojis icons package (from list: 11537, 11538, 11539).
 * 
 * @apiParamExample {json} param example:
 * {
 *  "pack_id": "11537"
 * }
 *
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *     [
 *        {"id": 1, "package_id": "11537", "line_emoji_id": "52002734"},
 *        {"id": 2, "package_id": "11537", "line_emoji_id": "52002735"}
 *     ]
 *
 * @apiError [InvalidAccessToken] Access Token is invalid.
 *
 * @apiErrorExample InvalidAccessToken Error-Response:
 *     HTTP/1.1 403 Permission denied
 *     {
 *       "status": "error",
 *       "message": "Access token is invalid"
 *     }

 * @apiError [AlreadyLogedOut] Already logedout before.
 *
 * @apiErrorExample AlreadyLogedOut Error-Response:
 *     HTTP/1.1 422 Unprocessable Entity
 *     {
 *       "status": "error",
 *       "message": "Already logedout before"
 *     }
 */

/**
 * @api {post} /api/v1/staff/channels/:channel_id/messages Send emoji message
 * @apiPermission yes
 * @apiName SendEmojiMessage
 * @apiGroup Chat APIs
 *
 * @apiHeader {String} Authorization store access_token value
 * @apiHeaderExample {Header} Header-Example
 *   "Authorization": "Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz"
 * @apiParam {Number} channel_id Id of channel.
 * @apiParam {Object} message message data.
 * @apiParam {String} message[type]=sticker type of message.
 * @apiParam {Number} message[packageId] id of emojis icons package (from list: 11537, 11538, 11539).
 * @apiParam {Number} message[stickerId] id of emoji icon
 * @apiParam {String} message[stickerResourceType]=STATIC emojis resource type.
 * 
 * @apiParamExample {json} param example:
 * {
 *  "channel_id": "1", 
 *  "message": {
 *    "type": "sticker", 
 *    "packageId": "11537", 
 *    "stickerId": "52002741", 
 *    "stickerResourceType": "STATIC"
 *  }
 * }
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *      {"id": 5,
 *        "line_message_id": nil,
 *        "timestamp": "2021-12-27 17:52:45 +0900",
 *        "text": "スタンプを送信しました",
 *        "content": {"type": "sticker", "packageId": "11537", "stickerId": "52002741", "stickerResourceType": "STATIC"},
 *        "from": "user",
 *        "status": "sent",
 *        "sender": {"id": 4, "name": "staff 1", "avatar_url": nil}}
 *
 * @apiError [InvalidAccessToken] Access Token is invalid.
 *
 * @apiErrorExample InvalidAccessToken Error-Response:
 *     HTTP/1.1 403 Permission denied
 *     {
 *       "status": "error",
 *       "message": "Access token is invalid"
 *     }

 * @apiError [AlreadyLogedOut] Already logedout before.
 *
 * @apiErrorExample AlreadyLogedOut Error-Response:
 *     HTTP/1.1 422 Unprocessable Entity
 *     {
 *       "status": "error",
 *       "message": "Already logedout before"
 *     }
 * 
 * @apiError [BadRequest] Bad request.
 *
 * @apiErrorExample BadRequest Error-Response:
 *     HTTP/1.1 400 BadRequest
 *     {
 *       "status": "error",
 *       "message": "Bad request"
 *     }
 * 
 * @apiError [NotAuthorized] You don't have permission to do this action (403).
 *
 * @apiErrorExample NotAuthorized Error-Response:
 *     HTTP/1.1 403 Permission denied
 *     {
 *       "status": "error",
 *       "message": "You don't have permission to do this action (403)"
 *     }
 */ 