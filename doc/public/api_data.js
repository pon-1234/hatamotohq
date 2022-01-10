define({ "api": [
  {
    "type": "post",
    "url": "/api/v1/staff/login",
    "title": "Staff Login",
    "permission": [
      {
        "name": "none"
      }
    ],
    "name": "Login",
    "group": "Authenticate",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "email",
            "description": "<p>Staff email.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "password",
            "description": "<p>Staff password.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "param example:",
          "content": "{\n  \"email\": \"staff1@example.com\", \n  \"password\": \"Staff12345@\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "status",
            "description": "<p>api response status.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>return data.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "data[accessToken]",
            "description": "<p>Access Token.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n  \"status\": \"success\",\n  \"data\": {\n     accessToken: 'leohssnxnxksjwaioiwcmchs1223ksshdkkslslscncnxjssk'\n  }  \n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "StaffNotAuthenticated",
            "description": "<p>Authenticate staff has been failed.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 401 Not Authenticated\n{\n  \"status\": \"error\",\n  \"message\": \"メールアドレスまたはパスワードが違います。\"\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "doc/api/staff_authenticate.js",
    "groupTitle": "Authenticate"
  },
  {
    "type": "delete",
    "url": "/api/v1/staff/logout",
    "title": "Staff Logout",
    "permission": [
      {
        "name": "yes"
      }
    ],
    "name": "Logout",
    "group": "Authenticate",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "Authorization",
            "description": "<p>store access_token value</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example",
          "content": "\"Authorization\": \"Bearer leohssnxnxksjwaioiwcmchs1223ksshdkkslslscncnxjssk\"",
          "type": "Header"
        }
      ]
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "status",
            "description": "<p>api response status.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n  \"status\": \"success\",\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "InvalidAccessToken",
            "description": "<p>Access Token is invalid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "AlreadyLogedOut",
            "description": "<p>Already logedout before.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"Access token is invalid\"\n}",
          "type": "json"
        },
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 422 Unprocessable Entity\n{\n  \"status\": \"error\",\n  \"message\": \"Already logedout before\"\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "doc/api/staff_authenticate.js",
    "groupTitle": "Authenticate"
  },
  {
    "type": "get",
    "url": "/api/v1/staff/channels",
    "title": "Get channel list",
    "permission": [
      {
        "name": "yes"
      }
    ],
    "name": "GetChannelList",
    "group": "Chat_APIs",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "Authorization",
            "description": "<p>store access_token value</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example",
          "content": "\"Authorization\": \"Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz\"",
          "type": "Header"
        }
      ]
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Object",
            "optional": true,
            "field": "q",
            "description": "<p>Search data.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": true,
            "field": "q[line_friend_display_name_or_line_friend_line_name_or_line_friend_tags_name_cont]",
            "description": "<p>Keyword for searching channel.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "param example:",
          "content": "{\n \"q\": {\"line_friend_display_name_or_line_friend_line_name_or_line_friend_tags_name_cont\": \"sample\"}\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n \"data\": [{\n   \"id\": 1,\n    \"title\": \"sample name\",\n    \"locked\": false,\n    \"line_friend_id\": 1,\n    \"last_message\": \"Hi \",\n    \"last_activity_at\": \"2021-12-27T17:20:36.000+09:00\",\n    \"last_seen_at\": \"2021-12-28T17:32:51.000+09:00\",\n    \"assignee_id\": 4,\n    \"unread_count\": 0,\n    \"line_friend\": \n     {\"id\": 1,\n      \"line_picture_url\": nil,\n      \"created_at\": \"2021-12-27T17:03:30.407+09:00\",\n      \"status\": \"active\",\n      \"line_name\": \"line friend name\",\n      \"display_name\": \"line friend name\",\n      \"note\": nil,\n      \"locked\": false,\n      \"visible\": true,\n      \"name\": \"friend name\",\n      \"avatar_url\": nil,\n      \"channel\": {\"id\": 1, \"title\": \"sample name\", \"assignee_id\": 4},\n      \"tags\": []}\n     }\n  ]}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "InvalidAccessToken",
            "description": "<p>Access Token is invalid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "AlreadyLogedOut",
            "description": "<p>Already logedout before.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "NotAuthorized",
            "description": "<p>You don't have permission to do this action (403).</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "InvalidAccessToken Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"Access token is invalid\"\n}",
          "type": "json"
        },
        {
          "title": "AlreadyLogedOut Error-Response:",
          "content": "HTTP/1.1 422 Unprocessable Entity\n{\n  \"status\": \"error\",\n  \"message\": \"Already logedout before\"\n}",
          "type": "json"
        },
        {
          "title": "NotAuthorized Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"You don't have permission to do this action (403)\"\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "doc/api/chat_apis.js",
    "groupTitle": "Chat_APIs"
  },
  {
    "type": "get",
    "url": "/api/v1/staff/emojis/:pack_id",
    "title": "Get emojis icon list for a package",
    "permission": [
      {
        "name": "yes"
      }
    ],
    "name": "GetEmojisIconList",
    "group": "Chat_APIs",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "Authorization",
            "description": "<p>store access_token value</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example",
          "content": "\"Authorization\": \"Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz\"",
          "type": "Header"
        }
      ]
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "pack_id",
            "description": "<p>id of line emojis icons package (from list: 11537, 11538, 11539).</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "param example:",
          "content": "{\n \"pack_id\": \"11537\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n[\n   {\"id\": 1, \"package_id\": \"11537\", \"line_emoji_id\": \"52002734\"},\n   {\"id\": 2, \"package_id\": \"11537\", \"line_emoji_id\": \"52002735\"}\n]",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "InvalidAccessToken",
            "description": "<p>Access Token is invalid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "AlreadyLogedOut",
            "description": "<p>Already logedout before.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "InvalidAccessToken Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"Access token is invalid\"\n}",
          "type": "json"
        },
        {
          "title": "AlreadyLogedOut Error-Response:",
          "content": "HTTP/1.1 422 Unprocessable Entity\n{\n  \"status\": \"error\",\n  \"message\": \"Already logedout before\"\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "doc/api/send_emoji_apis.js",
    "groupTitle": "Chat_APIs"
  },
  {
    "type": "get",
    "url": "/api/v1/staff/medias",
    "title": "Get media list",
    "permission": [
      {
        "name": "yes"
      }
    ],
    "name": "GetMediaList",
    "group": "Chat_APIs",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "Authorization",
            "description": "<p>store access_token value</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example",
          "content": "\"Authorization\": \"Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz\"",
          "type": "Header"
        }
      ]
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "object",
            "optional": true,
            "field": "q",
            "description": "<p>search data</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": true,
            "field": "page",
            "description": "<p>For pagination</p>"
          },
          {
            "group": "Parameter",
            "type": "Array",
            "optional": true,
            "field": "q[type_in]",
            "description": "<p>media type list (from image, audio, video, richmenu)</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "param example:",
          "content": "{\n  \"page\": \"1\", \n  \"q\": {\n     \"type_in\": [\"image\", \"audio\", \"video\", \"richmenu\"]\n  }\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n  \"meta\": {\"total_pages\": 1, \"current_page\": 1, \"total_count\": 4, \"limit_value\": 10},\n  \"data\": \n    [{\"id\": 4,\n      \"type\": \"video\",\n      \"url\": \"http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--d8a38e7752116e9fb4298c52eaa5dba6aa1c55ae/sample_video.mp4\",\n      \"preview_url\": nil,\n      \"download_url\": \n       \"http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--d8a38e7752116e9fb4298c52eaa5dba6aa1c55ae/sample_video.mp4\",\n      \"file_name\": \"sample_video.mp4\",\n      \"duration\": nil},\n     {\"id\": 3,\n     \"type\": \"audio\",\n      \"url\": \"http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f404ec3a6365041952f944b2cb91f12a5bf4edf2/sample3.m4a\",\n      \"preview_url\": nil,\n     \"download_url\": \n       \"http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f404ec3a6365041952f944b2cb91f12a5bf4edf2/sample3.m4a\",\n      \"file_name\": \"sample3.m4a\",\n      \"duration\": 105797.0},\n     {\"id\": 2,\n      \"type\": \"image\",\n      \"url\": \"http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--a52a378ecd8700901f9ea5e9c56976c1b4d3f3db/pic2.png\",\n      \"preview_url\": \"http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--a52a378ecd8700901f9ea5e9c56976c1b4d3f3db/pic2.png\",\n      \"download_url\": \n       \"http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--a52a378ecd8700901f9ea5e9c56976c1b4d3f3db/pic2.png\",\n      \"file_name\": \"pic2.png\",\n      \"duration\": nil},\n    }]\n  }",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "InvalidAccessToken",
            "description": "<p>Access Token is invalid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "AlreadyLogedOut",
            "description": "<p>Already logedout before.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "NotAuthorized",
            "description": "<p>You don't have permission to do this action (403).</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 403 InvalidAccessToken Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"Access token is invalid\"\n}",
          "type": "json"
        },
        {
          "title": "AlreadyLogedOut Error-Response:",
          "content": "HTTP/1.1 422 Unprocessable Entity\n{\n  \"status\": \"error\",\n  \"message\": \"Already logedout before\"\n}",
          "type": "json"
        },
        {
          "title": "NotAuthorized Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"You don't have permission to do this action (403)\"\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "doc/api/send_media_file_apis.js",
    "groupTitle": "Chat_APIs"
  },
  {
    "type": "get",
    "url": "/api/v1/staff/channels/:channel_id/messages",
    "title": "Get message list",
    "permission": [
      {
        "name": "yes"
      }
    ],
    "name": "GetMessageList",
    "group": "Chat_APIs",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "Authorization",
            "description": "<p>store access_token value</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example",
          "content": "\"Authorization\": \"Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz\"",
          "type": "Header"
        }
      ]
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "channel_id",
            "description": "<p>Id of channel</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "param example:",
          "content": "{\n \"channel_id\": \"1\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n  \"meta\": {\"last_seen_at\": \"2021-12-28T17:32:51.000+09:00\"},\n   \"data\": \n    [\n      {\"id\": 3,\n        \"line_message_id\": \"15317393604948\",\n        \"timestamp\": \"2021-12-27 17:20:36 +0900\",\n        \"text\": \"Hi\",\n        \"content\": {\"id\": \"15317393604948\", \"text\": \"Hi \", \"type\": \"text\"},\n        \"from\": \"friend\",\n        \"status\": \"sent\",\n        \"sender\": {\"id\": 1, \"name\": \"sample name\", \"avatar_url\": nil}},\n      {\n        \"id\": 2,\n        \"line_message_id\": nil,\n        \"timestamp\": \"2021-12-27 17:15:31 +0900\",\n        \"text\": \"hello\",\n        \"content\": {\"text\": \"hello\", \"type\": \"text\"},\n        \"from\": \"user\",\n        \"status\": \"sent\",\n        \"sender\": {\"id\": 4, \"name\": \"staff 1\", \"avatar_url\": nil}\n     }\n   ]\n }",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "InvalidAccessToken",
            "description": "<p>Access Token is invalid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "AlreadyLogedOut",
            "description": "<p>Already logedout before.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "InvalidAccessToken Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"Access token is invalid\"\n}",
          "type": "json"
        },
        {
          "title": "AlreadyLogedOut Error-Response:",
          "content": "HTTP/1.1 422 Unprocessable Entity\n{\n  \"status\": \"error\",\n  \"message\": \"Already logedout before\"\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "doc/api/chat_apis.js",
    "groupTitle": "Chat_APIs"
  },
  {
    "type": "get",
    "url": "/api/v1/staff/channels/:id/scenarios",
    "title": "Get scenario list",
    "permission": [
      {
        "name": "yes"
      }
    ],
    "name": "GetScenarioList",
    "group": "Chat_APIs",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "Authorization",
            "description": "<p>store access_token value</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example",
          "content": "\"Authorization\": \"Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz\"",
          "type": "Header"
        }
      ]
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>Id of channel</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "param example:",
          "content": "{\n \"id\": 1\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n  \"meta\": {\"total_pages\": 1, \"current_page\": 1, \"total_count\": 1, \"limit_value\": 8},\n   \"data\": \n    [{\"id\": 1,\n      \"title\": \"sample title\",\n      \"description\": \"sample description\",\n      \"mode\": \"elapsed_time\",\n      \"status\": \"enabled\",\n      \"type\": \"manual\",\n      \"scenario_messages_count\": 1,\n      \"after_action\": \n       {\"data\": {\"actions\": [{\"type\": \"text\", \"content\": {\"text\": \"start senario\"}}], \"displayText\": nil},\n        \"type\": \"postback\",\n        \"label\": nil,\n        \"displayText\": nil},\n      \"tags\": []}]\n  }",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "InvalidAccessToken",
            "description": "<p>Access Token is invalid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "AlreadyLogedOut",
            "description": "<p>Already logedout before.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "NotAuthorized",
            "description": "<p>You don't have permission to do this action (403).</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "InvalidAccessToken Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"Access token is invalid\"\n}",
          "type": "json"
        },
        {
          "title": "AlreadyLogedOut Error-Response:",
          "content": "HTTP/1.1 422 Unprocessable Entity\n{\n  \"status\": \"error\",\n  \"message\": \"Already logedout before\"\n}",
          "type": "json"
        },
        {
          "title": "NotAuthorized Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"You don't have permission to do this action (403)\"\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "doc/api/send_scenario_apis.js",
    "groupTitle": "Chat_APIs"
  },
  {
    "type": "get",
    "url": "/api/v1/staff/templates",
    "title": "Get template list",
    "permission": [
      {
        "name": "yes"
      }
    ],
    "name": "GetTemplateList",
    "group": "Chat_APIs",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "Authorization",
            "description": "<p>store access_token value</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example",
          "content": "\"Authorization\": \"Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz\"",
          "type": "Header"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n[{\n  \"id\": 19,\n  \"name\": \"holtel\",\n  \"templates\": [{\"id\": 1, \"folder_id\": 19, \"name\": \"sample name\", \"template_messages_count\": 1, \"created_at\": \"2021-12-27 18:27\"}]\n}]",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "InvalidAccessToken",
            "description": "<p>Access Token is invalid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "AlreadyLogedOut",
            "description": "<p>Already logedout before.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "InvalidAccessToken Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"Access token is invalid\"\n}",
          "type": "json"
        },
        {
          "title": "AlreadyLogedOut Error-Response:",
          "content": "HTTP/1.1 422 Unprocessable Entity\n{\n  \"status\": \"error\",\n  \"message\": \"Already logedout before\"\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "doc/api/send_template_apis.js",
    "groupTitle": "Chat_APIs"
  },
  {
    "type": "post",
    "url": "/api/v1/staff/channels/:channel_id/messages/send_scenario",
    "title": "Send a scenario",
    "permission": [
      {
        "name": "yes"
      }
    ],
    "name": "SendCenario",
    "group": "Chat_APIs",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "Authorization",
            "description": "<p>store access_token value</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example",
          "content": "\"Authorization\": \"Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz\"",
          "type": "Header"
        }
      ]
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "channel_id",
            "description": "<p>Id of channel .</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "scenario_id",
            "description": "<p>Id of scenario.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "param example:",
          "content": "{\n \"channel_id\": \"1\", \n \"scenario_id\": \"1\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n  \"status\": \"success\",\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "InvalidAccessToken",
            "description": "<p>Access Token is invalid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "AlreadyLogedOut",
            "description": "<p>Already logedout before.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "NotAuthorized",
            "description": "<p>You don't have permission to do this action (403).</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 403 InvalidAccessToken Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"Access token is invalid\"\n}",
          "type": "json"
        },
        {
          "title": "AlreadyLogedOut Error-Response:",
          "content": "HTTP/1.1 422 Unprocessable Entity\n{\n  \"status\": \"error\",\n  \"message\": \"Already logedout before\"\n}",
          "type": "json"
        },
        {
          "title": "NotAuthorized Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"You don't have permission to do this action (403)\"\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "doc/api/send_scenario_apis.js",
    "groupTitle": "Chat_APIs"
  },
  {
    "type": "post",
    "url": "/api/v1/staff/channels/:channel_id/messages",
    "title": "Send emoji message",
    "permission": [
      {
        "name": "yes"
      }
    ],
    "name": "SendEmojiMessage",
    "group": "Chat_APIs",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "Authorization",
            "description": "<p>store access_token value</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example",
          "content": "\"Authorization\": \"Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz\"",
          "type": "Header"
        }
      ]
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "channel_id",
            "description": "<p>Id of channel.</p>"
          },
          {
            "group": "Parameter",
            "type": "Object",
            "optional": false,
            "field": "message",
            "description": "<p>message data.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "message[type]",
            "defaultValue": "sticker",
            "description": "<p>type of message.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "message[packageId]",
            "description": "<p>id of emojis icons package (from list: 11537, 11538, 11539).</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "message[stickerId]",
            "description": "<p>id of emoji icon</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": true,
            "field": "message[stickerResourceType]",
            "defaultValue": "STATIC",
            "description": "<p>emojis resource type.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "param example:",
          "content": "{\n \"channel_id\": \"1\", \n \"message\": {\n   \"type\": \"sticker\", \n   \"packageId\": \"11537\", \n   \"stickerId\": \"52002741\", \n   \"stickerResourceType\": \"STATIC\"\n }\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n {\"id\": 5,\n   \"line_message_id\": nil,\n   \"timestamp\": \"2021-12-27 17:52:45 +0900\",\n   \"text\": \"スタンプを送信しました\",\n   \"content\": {\"type\": \"sticker\", \"packageId\": \"11537\", \"stickerId\": \"52002741\", \"stickerResourceType\": \"STATIC\"},\n   \"from\": \"user\",\n   \"status\": \"sent\",\n   \"sender\": {\"id\": 4, \"name\": \"staff 1\", \"avatar_url\": nil}}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "InvalidAccessToken",
            "description": "<p>Access Token is invalid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "AlreadyLogedOut",
            "description": "<p>Already logedout before.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "UnprocessableEntity",
            "description": "<p>Unprocessable Entity.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "NotAuthorized",
            "description": "<p>You don't have permission to do this action (403).</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "InvalidAccessToken Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"Access token is invalid\"\n}",
          "type": "json"
        },
        {
          "title": "AlreadyLogedOut Error-Response:",
          "content": "HTTP/1.1 422 Unprocessable Entity\n{\n  \"status\": \"error\",\n  \"message\": \"Already logedout before\"\n}",
          "type": "json"
        },
        {
          "title": "UnprocessableEntity Error-Response:",
          "content": "HTTP/1.1 422 UnprocessableEntity\n{\n  \"error\": \"バリデーションに失敗しました: Typeを入力してください\"\n}",
          "type": "json"
        },
        {
          "title": "NotAuthorized Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"You don't have permission to do this action (403)\"\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "doc/api/send_emoji_apis.js",
    "groupTitle": "Chat_APIs"
  },
  {
    "type": "post",
    "url": "/api/v1/staff/channels/:channel_id/messages",
    "title": "Send media message",
    "permission": [
      {
        "name": "yes"
      }
    ],
    "name": "SendMediaMessage",
    "group": "Chat_APIs",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "Authorization",
            "description": "<p>store access_token value</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example",
          "content": "\"Authorization\": \"Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz\"",
          "type": "Header"
        }
      ]
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "channel_id",
            "description": "<p>Id of channel</p>"
          },
          {
            "group": "Parameter",
            "type": "Object",
            "optional": false,
            "field": "message",
            "description": "<p>Messsage data</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "message[type]",
            "description": "<p>of media file (one of follow types: video, richmenu, imagemap)</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "message[originalContentUrl]",
            "description": "<p>url of recent uploaded media file</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": true,
            "field": "message[previewImageUrl]",
            "description": "<p>preview image url (image file only)</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": true,
            "field": "message[duration]",
            "description": "<p>duration of audio (audio file only)</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "param example:",
          "content": "{\n  \"channel_id\": \"1\", \n  \"message\": {\n    \"type\": \"image\", \n    \"originalContentUrl\": \"http://localhost:3000/abc.png\", \"previewImageUrl\": \"http://localhost:3000/abc1.png\"\n  }\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\"id\": 13,\n   \"line_message_id\": nil,\n   \"timestamp\": \"2021-12-27 19:14:28 +0900\",\n   \"text\": \"画像を送信しました\",\n   \"content\": \n    {\"type\": \"image\",\n     \"previewImageUrl\": \n      \"http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--a52a378ecd8700901f9ea5e9c56976c1b4d3f3db/pic2.png\",\n     \"originalContentUrl\": \n      \"http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--a52a378ecd8700901f9ea5e9c56976c1b4d3f3db/pic2.png\"},\n   \"from\": \"user\",\n   \"status\": \"success\",\n   \"sender\": {\"id\": 4, \"name\": \"staff 1\", \"avatar_url\": nil}}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "InvalidAccessToken",
            "description": "<p>Access Token is invalid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "AlreadyLogedOut",
            "description": "<p>Already logedout before.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "UnprocessableEntity",
            "description": "<p>Unprocessable Entity.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "NotAuthorized",
            "description": "<p>You don't have permission to do this action (403).</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "InvalidAccessToken Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"Access token is invalid\"\n}",
          "type": "json"
        },
        {
          "title": "AlreadyLogedOut Error-Response:",
          "content": "HTTP/1.1 422 Unprocessable Entity\n{\n  \"status\": \"error\",\n  \"message\": \"Already logedout before\"\n}",
          "type": "json"
        },
        {
          "title": "UnprocessableEntity Error-Response:",
          "content": "HTTP/1.1 422 UnprocessableEntity\n{\n  \"error\": \"バリデーションに失敗しました: Typeを入力してください\"\n}",
          "type": "json"
        },
        {
          "title": "NotAuthorized Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"You don't have permission to do this action (403)\"\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "doc/api/send_media_file_apis.js",
    "groupTitle": "Chat_APIs"
  },
  {
    "type": "post",
    "url": "/user/channels/:channel_id/messages/send_template",
    "title": "Send a template",
    "permission": [
      {
        "name": "yes"
      }
    ],
    "name": "SendTemplate",
    "group": "Chat_APIs",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "Authorization",
            "description": "<p>store access_token value</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example",
          "content": "\"Authorization\": \"Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz\"",
          "type": "Header"
        }
      ]
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "channel_id",
            "description": "<p>Id of channel.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "template_id",
            "description": "<p>Id of template.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "param example:",
          "content": "{\n \"channel_id\": \"1\", \n \"template_id\": 1\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n  \"status\": \"success\",\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "InvalidAccessToken",
            "description": "<p>Access Token is invalid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "AlreadyLogedOut",
            "description": "<p>Already logedout before.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "NotAuthorized",
            "description": "<p>You don't have permission to do this action (403).</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "InvalidAccessToken Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"Access token is invalid\"\n}",
          "type": "json"
        },
        {
          "title": "AlreadyLogedOut Error-Response:",
          "content": "HTTP/1.1 422 Unprocessable Entity\n{\n  \"status\": \"error\",\n  \"message\": \"Already logedout before\"\n}",
          "type": "json"
        },
        {
          "title": "NotAuthorized Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"You don't have permission to do this action (403)\"\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "doc/api/send_template_apis.js",
    "groupTitle": "Chat_APIs"
  },
  {
    "type": "post",
    "url": "/api/v1/staff/channels/:channel_id/messages",
    "title": "Send text message",
    "permission": [
      {
        "name": "yes"
      }
    ],
    "name": "SendTextMessage",
    "group": "Chat_APIs",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "Authorization",
            "description": "<p>store access_token value</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example",
          "content": "\"Authorization\": \"Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz\"",
          "type": "Header"
        }
      ]
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "channel_id",
            "description": "<p>Id of channel.</p>"
          },
          {
            "group": "Parameter",
            "type": "Object",
            "optional": false,
            "field": "message",
            "description": "<p>Message data.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "message[type]",
            "defaultValue": "text",
            "description": "<p>type of message is text.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "message[text]",
            "description": "<p>content of message.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "param example:",
          "content": "{\n  \"channel_id\": \"1\", \n  \"message\": \n  {\"type\": \"text\", \"text\": \"hello\"}\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n  \"id\": 12,\n  \"line_message_id\": null,\n  \"timestamp\": \"2021-12-27 18:54:09 +0900\",\n  \"text\": \"hello\",\n  \"content\": {\"text\": \"hello\", \"type\": \"text\"},\n  \"from\": \"user\",\n  \"status\": \"sent\",\n  \"sender\": {\"id\": 3, \"name\": \"admin1\", \"avatar_url\": null}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "InvalidAccessToken",
            "description": "<p>Access Token is invalid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "AlreadyLogedOut",
            "description": "<p>Already logedout before.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "UnprocessableEntity",
            "description": "<p>Unprocessable Entity.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "NotAuthorized",
            "description": "<p>You don't have permission to do this action (403).</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "InvalidAccessToken Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"Access token is invalid\"\n}",
          "type": "json"
        },
        {
          "title": "AlreadyLogedOut Error-Response:",
          "content": "HTTP/1.1 422 Unprocessable Entity\n{\n  \"status\": \"error\",\n  \"message\": \"Already logedout before\"\n}",
          "type": "json"
        },
        {
          "title": "UnprocessableEntity Error-Response:",
          "content": "HTTP/1.1 422 UnprocessableEntity\n{\n  \"error\": \"バリデーションに失敗しました: Typeを入力してください\"\n}",
          "type": "json"
        },
        {
          "title": "NotAuthorized Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"You don't have permission to do this action (403)\"\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "doc/api/chat_apis.js",
    "groupTitle": "Chat_APIs"
  },
  {
    "type": "post",
    "url": "/api/v1/staff/channels/:id/update_last_seen",
    "title": "Update last seen at for channel",
    "permission": [
      {
        "name": "yes"
      }
    ],
    "name": "UpdateLastSeenAt",
    "group": "Chat_APIs",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "Authorization",
            "description": "<p>store access_token value</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example",
          "content": "\"Authorization\": \"Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz\"",
          "type": "Header"
        }
      ]
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>Id of channel</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "param example:",
          "content": "{\n \"id\": \"1\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n  \"status\": \"success\",\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "InvalidAccessToken",
            "description": "<p>Access Token is invalid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "AlreadyLogedOut",
            "description": "<p>Already logedout before.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "NotAuthorized",
            "description": "<p>You don't have permission to do this action (403).</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "InvalidAccessToken Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"Access token is invalid\"\n}",
          "type": "json"
        },
        {
          "title": "AlreadyLogedOut Error-Response:",
          "content": "HTTP/1.1 422 Unprocessable Entity\n{\n  \"status\": \"error\",\n  \"message\": \"Already logedout before\"\n}",
          "type": "json"
        },
        {
          "title": "NotAuthorized Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"You don't have permission to do this action (403)\"\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "doc/api/chat_apis.js",
    "groupTitle": "Chat_APIs"
  },
  {
    "type": "post",
    "url": "/api/v1/staff/medias",
    "title": "Upload a media file",
    "permission": [
      {
        "name": "yes"
      }
    ],
    "name": "UploadFile",
    "group": "Chat_APIs",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "Authorization",
            "description": "<p>store access_token value</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example",
          "content": "\"Authorization\": \"Bearer 5f048fe321sadbggdj234642412daszvbhhZzxz\"",
          "type": "Header"
        }
      ]
    },
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "File",
            "optional": false,
            "field": "file",
            "description": "<p>file</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "type",
            "description": "<p>One of follow types: image, audio, video, richmenu, imagemap</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": true,
            "field": "duration",
            "description": "<p>Duration of audio (audio file only)</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "param example:",
          "content": "{\n  \"file\": file object,\n  \"type\": \"image\"\n}",
          "type": "json"
        }
      ]
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": " HTTP/1.1 200 OK\n {\n  \"id\": 1,\n  \"type\": \"image\",\n  \"url\": \n   \"http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--36c84e6956079e601d075fc270357e9bcf46971b/Screenshot%20from%202021-12-27%2015-55-42.png\",\n  \"preview_url\": \n   \"http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--36c84e6956079e601d075fc270357e9bcf46971b/Screenshot%20from%202021-12-27%2015-55-42.png\",\n  \"download_url\": \n   \"http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--36c84e6956079e601d075fc270357e9bcf46971b/Screenshot%20from%202021-12-27%2015-55-42.png\",\n  \"file_name\": \"Screenshot from 2021-12-27 15-55-42.png\",\n  \"duration\": nil\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "InvalidAccessToken",
            "description": "<p>Access Token is invalid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "AlreadyLogedOut",
            "description": "<p>Already logedout before.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "BadRequest",
            "description": "<p>Bad request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": true,
            "field": "NotAuthorized",
            "description": "<p>You don't have permission to do this action (403).</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "InvalidAccessToken Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"Access token is invalid\"\n}",
          "type": "json"
        },
        {
          "title": "AlreadyLogedOut Error-Response:",
          "content": "HTTP/1.1 422 Unprocessable Entity\n{\n  \"status\": \"error\",\n  \"message\": \"Already logedout before\"\n}",
          "type": "json"
        },
        {
          "title": "BadRequest Error-Response:",
          "content": "HTTP/1.1 400 BadRequest\n{\n  \"status\": \"error\",\n  \"message\": \"ファイル画像の幅はちょうど1040にしてください。\"\n}",
          "type": "json"
        },
        {
          "title": "NotAuthorized Error-Response:",
          "content": "HTTP/1.1 403 Permission denied\n{\n  \"status\": \"error\",\n  \"message\": \"You don't have permission to do this action (403)\"\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "doc/api/send_media_file_apis.js",
    "groupTitle": "Chat_APIs"
  }
] });
