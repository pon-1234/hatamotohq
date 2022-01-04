/**
 * @api {post} /api/v1/staff/login Staff Login
 * @apiPermission none
 * @apiName Login
 * @apiGroup Authenticate
 *
 * @apiParam {String} email Staff email.
 * @apiParam {String} password Staff password.
 *
 * @apiSuccess {String} status api response status.
 * @apiSuccess {Object} data return data.
 * @apiSuccess {String} data[accessToken] Access Token.
 *
 * @apiSuccessExample Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *       "status": "success",
 *       "data": {
 *          accessToken: 'leohssnxnxksjwaioiwcmchs1223ksshdkkslslscncnxjssk'
 *       }  
 *     }
 *
 * @apiError [StaffNotAuthenticated] Authenticate staff has been failed.
 *
 * @apiErrorExample Error-Response:
 *     HTTP/1.1 401 Not Authenticated
 *     {
 *       "status": "error",
 *       "message": "メールアドレスまたはパスワードが違います。"
 *     }
 *
 *
 */
 
 /**
 * @api {delete} /api/v1/staff/logout Staff Logout
 * @apiPermission yes
 * @apiName Logout
 * @apiGroup Authenticate
 *
 * @apiHeader {String} Authorization store access_token value
 * @apiHeaderExample {Header} Header-Example
 *     "Authorization": "Bearer leohssnxnxksjwaioiwcmchs1223ksshdkkslslscncnxjssk"
 *
 * @apiSuccess {String} status api response status.
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
 *     HTTP/1.1 403 Permission denied
 *     {
 *       "status": "error",
 *       "message": "Access token is invalid"
 *     }

 * @apiError [AlreadyLogedOut] Already logedout before.
 *
 * @apiErrorExample Error-Response:
 *     HTTP/1.1 422 Unprocessable Entity
 *     {
 *       "status": "error",
 *       "message": "Already logedout before"
 *     }
 */
