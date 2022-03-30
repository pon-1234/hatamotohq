/**
 * @api {get} /api/v1/staff/channels/:id/scenarios Get scenario list
 * @apiPermission yes
 * @apiName GetScenarioList
 * @apiGroup Chat APIs
 *
 * @apiHeader {String} Authorization store access_token value
 * @apiHeaderExample {Header} Header-Example
 *     "Authorization": "Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz"
 * @apiParam {Number} id Id of channel 
 * 
 * @apiParamExample {json} param example:
 * {
 *  "id": 1
 * }
 * 
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *       "meta": {"total_pages": 1, "current_page": 1, "total_count": 1, "limit_value": 8},
 *        "data": 
 *         [{"id": 1,
 *           "title": "sample title",
 *           "description": "sample description",
 *           "mode": "elapsed_time",
 *           "status": "enabled",
 *           "type": "manual",
 *           "scenario_messages_count": 1,
 *           "after_action": 
 *            {"data": {"actions": [{"type": "text", "content": {"text": "start senario"}}], "displayText": nil},
 *             "type": "postback",
 *             "label": nil,
 *             "displayText": nil},
 *           "tags": []}]
 *       }
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
 
 /**
 * @api {post} /api/v1/staff/channels/:channel_id/messages/send_scenario Send a scenario
 * @apiPermission yes
 * @apiName SendCenario
 * @apiGroup Chat APIs
 *
 * @apiHeader {String} Authorization store access_token value
 * @apiHeaderExample {Header} Header-Example
 *     "Authorization": "Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz"
 * @apiParam {Number} channel_id Id of channel .
 * @apiParam {Number} scenario_id Id of scenario.
 * 
 * @apiParamExample {json} param example:
 * {
 *  "channel_id": "1", 
 *  "scenario_id": "1"
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
 * @apiError [NotAuthorized] You don't have permission to do this action (403).
 *
 * @apiErrorExample NotAuthorized Error-Response:
 *     HTTP/1.1 403 Permission denied
 *     {
 *       "status": "error",
 *       "message": "You don't have permission to do this action (403)"
 *     }
 */