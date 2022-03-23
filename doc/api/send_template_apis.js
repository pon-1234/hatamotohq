/**
 * @api {get} /api/v1/staff/templates Get template list
 * @apiPermission yes
 * @apiName GetTemplateList
 * @apiGroup Chat APIs
 *
 * @apiHeader {String} Authorization store access_token value
 * @apiHeaderExample {Header} Header-Example
 *     "Authorization": "Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz"
 * 
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *     [{
 *       "id": 19,
 *       "name": "holtel",
 *       "templates": [{"id": 1, "folder_id": 19, "name": "sample name", "template_messages_count": 1, "created_at": "2021-12-27 18:27"}]
 *     }]
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
 * @api {post} /user/channels/:channel_id/messages/send_template Send a template
 * @apiPermission yes
 * @apiName SendTemplate
 * @apiGroup Chat APIs
 *
 * @apiHeader {String} Authorization store access_token value
 * @apiHeaderExample {Header} Header-Example
 *     "Authorization": "Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz"
 * @apiParam {Number} channel_id Id of channel.
 * @apiParam {Number} template_id Id of template.
 *
 * @apiParamExample {json} param example:
 * {
 *  "channel_id": "1", 
 *  "template_id": 1
 * }
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
 * @apiError [NotAuthorized] You don't have permission to do this action (403).
 *
 * @apiErrorExample NotAuthorized Error-Response:
 *     HTTP/1.1 403 Permission denied
 *     {
 *       "status": "error",
 *       "message": "You don't have permission to do this action (403)"
 *     }
 */