/**
 * @api {get} /api/v1/staff/medias Get media list
 * @apiPermission yes
 * @apiName GetMediaList
 * @apiGroup Chat APIs
 *
 * @apiHeader {String} Authorization store access_token value
 * @apiHeaderExample {Header} Header-Example
 *     "Authorization": "Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz"
 * @apiParam {object} [q] search data
 * @apiParam {Number} [page] For pagination
 * @apiParam {Array} [q[type_in]] media type list (from image, audio, video, richmenu)
 * 
 * @apiParamExample {json} param example:
 * {
 *   "page": "1", 
 *   "q": {
 *      "type_in": ["image", "audio", "video", "richmenu"]
 *   }
 * }
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *       "meta": {"total_pages": 1, "current_page": 1, "total_count": 4, "limit_value": 10},
 *       "data": 
 *         [{"id": 4,
 *           "type": "video",
 *           "url": "http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--d8a38e7752116e9fb4298c52eaa5dba6aa1c55ae/sample_video.mp4",
 *           "preview_url": nil,
 *           "download_url": 
 *            "http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--d8a38e7752116e9fb4298c52eaa5dba6aa1c55ae/sample_video.mp4",
 *           "file_name": "sample_video.mp4",
 *           "duration": nil},
 *          {"id": 3,
 *          "type": "audio",
 *           "url": "http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f404ec3a6365041952f944b2cb91f12a5bf4edf2/sample3.m4a",
 *           "preview_url": nil,
 *          "download_url": 
 *            "http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f404ec3a6365041952f944b2cb91f12a5bf4edf2/sample3.m4a",
 *           "file_name": "sample3.m4a",
 *           "duration": 105797.0},
 *          {"id": 2,
 *           "type": "image",
 *           "url": "http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--a52a378ecd8700901f9ea5e9c56976c1b4d3f3db/pic2.png",
 *           "preview_url": "http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--a52a378ecd8700901f9ea5e9c56976c1b4d3f3db/pic2.png",
 *           "download_url": 
 *            "http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--a52a378ecd8700901f9ea5e9c56976c1b4d3f3db/pic2.png",
 *           "file_name": "pic2.png",
 *           "duration": nil},
 *         }]
 *       }
 *
 * @apiError [InvalidAccessToken] Access Token is invalid.
 *
 * @apiErrorExample Error-Response:
 *     HTTP/1.1 403 InvalidAccessToken Permission denied
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

/**
 * @api {post} /api/v1/staff/medias Upload a media file
 * @apiPermission yes
 * @apiName UploadFile
 * @apiGroup Chat APIs
 *
 * @apiHeader {String} Authorization store access_token value
 * @apiHeaderExample {Header} Header-Example
 *     "Authorization": "Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz"
 * @apiParam {File} file file
 * @apiParam {String} type One of follow types: image, audio, video
 * @apiParam {Number} [duration] Duration of audio (audio file only)
 * 
 * @apiParamExample {json} param example:
 * {
 *   "file": file object,
 *   "type": "image"
 * }
 *
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *      "id": 1,
 *      "type": "image",
 *      "url": 
 *       "http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--36c84e6956079e601d075fc270357e9bcf46971b/Screenshot%20from%202021-12-27%2015-55-42.png",
 *      "preview_url": 
 *       "http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--36c84e6956079e601d075fc270357e9bcf46971b/Screenshot%20from%202021-12-27%2015-55-42.png",
 *      "download_url": 
 *       "http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--36c84e6956079e601d075fc270357e9bcf46971b/Screenshot%20from%202021-12-27%2015-55-42.png",
 *      "file_name": "Screenshot from 2021-12-27 15-55-42.png",
 *      "duration": nil
 *    }     
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
 *     
 *  
 * @apiError [BadRequest] Bad request.
 *
 * @apiErrorExample BadRequest Error-Response:
 *     HTTP/1.1 400 BadRequest
 *     {
 *       "status": "error",
 *       "message": "画像の高さは1200以下にしてください。"
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
 * @api {post} /api/v1/staff/channels/:channel_id/messages Send media message
 * @apiPermission yes
 * @apiName SendMediaMessage
 * @apiGroup Chat APIs
 *
 * @apiHeader {String} Authorization store access_token value
 * @apiHeaderExample {Header} Header-Example
 *     "Authorization": "Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz"
 * @apiParam {Number} channel_id Id of channel
 * @apiParam {Object} message Messsage data
 * @apiParam {String} message[type] of media file (one of follow types: image, audio, video)
 * @apiParam {String} message[originalContentUrl] url of recent uploaded media file
 * @apiParam {String} [message[previewImageUrl]] preview image url (image file only)
 * @apiParam {String} [message[duration]] duration of audio (audio file only)
 * 
 * @apiParamExample {json} param example:
 * {
 *   "channel_id": "1", 
 *   "message": {
 *     "type": "image", 
 *     "originalContentUrl": "http://localhost:3000/abc.png", "previewImageUrl": "http://localhost:3000/abc1.png"
 *   }
 * }
 *
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *     {"id": 13,
 *        "line_message_id": nil,
 *        "timestamp": "2021-12-27 19:14:28 +0900",
 *        "text": "画像を送信しました",
 *        "content": 
 *         {"type": "image",
 *          "previewImageUrl": 
 *           "http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--a52a378ecd8700901f9ea5e9c56976c1b4d3f3db/pic2.png",
 *          "originalContentUrl": 
 *           "http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--a52a378ecd8700901f9ea5e9c56976c1b4d3f3db/pic2.png"},
 *        "from": "user",
 *        "status": "success",
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