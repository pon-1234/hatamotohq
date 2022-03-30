/**
 * @api {post} /api/v1/staff/channels/:channel_id/messages Send text message
 * @apiPermission yes
 * @apiName SendTextMessage
 * @apiGroup Chat APIs
 *
 * @apiHeader {String} Authorization store access_token value
 * @apiHeaderExample {Header} Header-Example
 *     "Authorization": "Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz"
 * @apiParam {Number} channel_id Id of channel.
 * @apiParam {Object} message Message data.
 * @apiParam {String} message[type]=text type of message is text.
 * @apiParam {String} message[text] content of message.
 * 
 * @apiParamExample {json} param example:
 * {
 *   "channel_id": "1", 
 *   "message": 
 *   {"type": "text", "text": "hello"}
 * }
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *       "id": 12,
 *       "line_message_id": null,
 *       "timestamp": "2021-12-27 18:54:09 +0900",
 *       "text": "hello",
 *       "content": {"text": "hello", "type": "text"},
 *       "from": "user",
 *       "status": "sent",
 *       "sender": {"id": 3, "name": "admin1", "avatar_url": null}
 *     }
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
 * @apiError [UnprocessableEntity] Unprocessable Entity.
 *
 * @apiErrorExample UnprocessableEntity Error-Response:
 *     HTTP/1.1 422 UnprocessableEntity
 *     {
 *       "error": "バリデーションに失敗しました: Typeを入力してください"
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

/**
 * @api {get} /api/v1/staff/channels Get channel list
 * @apiPermission yes
 * @apiName GetChannelList
 * @apiGroup Chat APIs
 *
 * @apiHeader {String} Authorization store access_token value
 * @apiHeaderExample {Header} Header-Example
 *     "Authorization": "Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz"
 * @apiParam {Object} [q] Search data.
 * @apiParam {String} [q[line_friend_display_name_or_line_friend_line_name_or_line_friend_tags_name_cont]] Keyword for searching channel.
 * 
 * @apiParamExample {json} param example:
 * {
 *  "q": {"line_friend_display_name_or_line_friend_line_name_or_line_friend_tags_name_cont": "sample"}
 * }
 * 
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *      "data": [{
 *        "id": 1,
 *         "title": "sample name",
 *         "locked": false,
 *         "line_friend_id": 1,
 *         "last_message": "Hi ",
 *         "last_activity_at": "2021-12-27T17:20:36.000+09:00",
 *         "last_seen_at": "2021-12-28T17:32:51.000+09:00",
 *         "assignee_id": 4,
 *         "unread_count": 0,
 *         "line_friend": 
   *          {"id": 1,
   *           "line_picture_url": nil,
   *           "created_at": "2021-12-27T17:03:30.407+09:00",
   *           "status": "active",
   *           "line_name": "line friend name",
   *           "display_name": "line friend name",
   *           "note": nil,
   *           "locked": false,
   *           "visible": true,
   *           "name": "friend name",
   *           "avatar_url": nil,
   *           "channel": {"id": 1, "title": "sample name", "assignee_id": 4},
   *           "tags": []}
   *          }
 *       ]}
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
 * @apiError [NotAuthorized] You don't have permission to do this action (403).
 *
 * @apiErrorExample NotAuthorized Error-Response:
 *     HTTP/1.1 403 Permission denied
 *     {
 *       "status": "error",
 *       "message": "You don't have permission to do this action (403)"
 *     }
 */

 /**
 * @api {get} /api/v1/staff/channels/:channel_id/messages Get message list
 * @apiPermission yes
 * @apiName GetMessageList
 * @apiGroup Chat APIs
 *
 * @apiHeader {String} Authorization store access_token value
 * @apiHeaderExample {Header} Header-Example
 *     "Authorization": "Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz"
 * @apiParam {Number} channel_id Id of channel
 * @apiParam {Number} [before] Id of current first message
 * 
 * @apiParamExample {json} param example:
 * {
 *  "channel_id": "1",
 *  "before": 100
 * }
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *       "meta": {"last_seen_at": "2021-12-28T17:32:51.000+09:00"},
 *        "data": 
 *         [
 *           {"id": 3,
 *             "line_message_id": "15317393604948",
 *             "timestamp": "2021-12-27 17:20:36 +0900",
 *             "text": "Hi",
 *             "content": {"id": "15317393604948", "text": "Hi ", "type": "text"},
 *             "from": "friend",
 *             "status": "sent",
 *             "sender": {"id": 1, "name": "sample name", "avatar_url": nil}},
 *           {
 *             "id": 2,
 *             "line_message_id": nil,
 *             "timestamp": "2021-12-27 17:15:31 +0900",
 *             "text": "hello",
 *             "content": {"text": "hello", "type": "text"},
 *             "from": "user",
 *             "status": "sent",
 *             "sender": {"id": 4, "name": "staff 1", "avatar_url": nil}
 *          }
 *        ]
 *      }
 *
 * @apiError [InvalidAccessToken] Access Token is invalid.
 *
 * @apiErrorExample InvalidAccessToken Error-Response:
 *     HTTP/1.1 403 Permission denied
 *     {
 *       "status": "error",
 *       "message": "Access token is invalid"
 *     }
 *
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
 * @api {post} /api/v1/staff/channels/:id/update_last_seen Update last seen at for channel
 * @apiPermission yes
 * @apiName UpdateLastSeenAt
 * @apiGroup Chat APIs
 *
 * @apiHeader {String} Authorization store access_token value
 * @apiHeaderExample {Header} Header-Example
 *     "Authorization": "Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz"
 * @apiParam {Number} id Id of channel
 * 
 * @apiParamExample {json} param example:
 * {
 *  "id": "1"
 * }
 * 
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *       "status": "success",
 *     }
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
 * @apiError [NotAuthorized] You don't have permission to do this action (403).
 *
 * @apiErrorExample NotAuthorized Error-Response:
 *     HTTP/1.1 403 Permission denied
 *     {
 *       "status": "error",
 *       "message": "You don't have permission to do this action (403)"
 *     }
 */
