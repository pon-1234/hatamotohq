# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_22_034103) do

  create_table "action_objects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.json "format"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "auto_response_keywords", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.bigint "auto_response_id"
    t.string "keyword"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["auto_response_id"], name: "index_auto_response_keywords_on_auto_response_id"
    t.index ["line_account_id"], name: "index_auto_response_keywords_on_line_account_id"
  end

  create_table "auto_response_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "auto_response_id"
    t.text "content"
    t.string "message_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["auto_response_id"], name: "index_auto_response_messages_on_auto_response_id"
  end

  create_table "auto_responses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.bigint "folder_id"
    t.string "title"
    t.string "status"
    t.string "keyword"
    t.string "keyword_status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["folder_id"], name: "index_auto_responses_on_folder_id"
    t.index ["line_account_id"], name: "index_auto_responses_on_line_account_id"
  end

  create_table "broadcast_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "broadcast_id"
    t.json "content"
    t.string "message_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["broadcast_id"], name: "index_broadcast_messages_on_broadcast_id"
  end

  create_table "broadcast_template_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "broadcast_template_id"
    t.string "message_type"
    t.text "content", size: :long
    t.integer "sort_order", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["broadcast_template_id"], name: "index_broadcast_template_messages_on_broadcast_template_id"
  end

  create_table "broadcast_templates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["line_account_id"], name: "index_broadcast_templates_on_line_account_id"
  end

  create_table "broadcasts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.json "conditions"
    t.string "title"
    t.string "date_start"
    t.boolean "deliver_now", default: true
    t.string "status"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["line_account_id"], name: "index_broadcasts_on_line_account_id"
  end

  create_table "channel_participants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "channel_id"
    t.string "participant_type"
    t.bigint "participant_id"
    t.integer "unread_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["channel_id"], name: "index_channel_participants_on_channel_id"
    t.index ["participant_type", "participant_id"], name: "index_participant_id_and_type_on_channel_participants"
  end

  create_table "channels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.bigint "line_friend_id"
    t.string "title"
    t.string "avatar"
    t.text "last_message"
    t.string "status", default: "1"
    t.string "alias"
    t.datetime "last_timestamp"
    t.string "slug"
    t.boolean "un_read", default: true
    t.boolean "is_mute", default: false
    t.boolean "is_pair_chat", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["line_account_id"], name: "index_channels_on_line_account_id"
    t.index ["line_friend_id"], name: "index_channels_on_line_friend_id"
  end

  create_table "emojis", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "package_id"
    t.string "line_emoji_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "flex_message_sent_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "flex_message_id"
    t.bigint "line_account_id"
    t.text "html_template", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["flex_message_id"], name: "index_flex_message_sent_logs_on_flex_message_id"
    t.index ["line_account_id"], name: "index_flex_message_sent_logs_on_line_account_id"
  end

  create_table "flex_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.string "name"
    t.json "json_message"
    t.json "json_template"
    t.text "html_template", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["line_account_id"], name: "index_flex_messages_on_line_account_id"
  end

  create_table "folders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.string "name"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["line_account_id"], name: "index_folders_on_line_account_id"
  end

  create_table "line_accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "owner_id"
    t.string "line_user_id"
    t.string "line_name"
    t.string "display_name"
    t.string "line_channel_id"
    t.string "line_channel_secret"
    t.string "line_channel_access_token"
    t.string "invite_url"
    t.string "webhook_url"
    t.string "liff_id"
    t.text "note"
    t.boolean "bot_initialized", default: false
    t.string "status", default: "inactive"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["owner_id"], name: "index_line_accounts_on_owner_id"
  end

  create_table "line_friends", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.string "line_picture_url"
    t.string "line_user_id"
    t.string "line_name"
    t.string "display_name"
    t.string "status", default: "active"
    t.text "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["line_account_id"], name: "index_line_friends_on_line_account_id"
  end

  create_table "login_activities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "scope"
    t.string "strategy"
    t.string "identity"
    t.boolean "success"
    t.string "failure_reason"
    t.string "user_type"
    t.bigint "user_id"
    t.string "context"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "city"
    t.string "region"
    t.string "country"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at"
    t.index ["identity"], name: "index_login_activities_on_identity"
    t.index ["ip"], name: "index_login_activities_on_ip"
    t.index ["user_type", "user_id"], name: "index_login_activities_on_user_type_and_user_id"
  end

  create_table "message_content_templates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "message_template_id"
    t.string "message_type"
    t.text "content", size: :long
    t.integer "num", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_template_id"], name: "index_message_content_templates_on_message_template_id"
  end

  create_table "message_templates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.bigint "folder_id"
    t.string "title"
    t.text "content", size: :long
    t.string "message_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["folder_id"], name: "index_message_templates_on_folder_id"
    t.index ["line_account_id"], name: "index_message_templates_on_line_account_id"
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "channel_id"
    t.bigint "line_friend_id"
    t.boolean "is_bot_sender", default: false
    t.string "attr", default: "chat-reserve"
    t.string "line_message_id"
    t.text "line_content", size: :long
    t.string "line_timestamp"
    t.string "line_reply_token"
    t.text "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["channel_id"], name: "index_messages_on_channel_id"
    t.index ["line_friend_id"], name: "index_messages_on_line_friend_id"
  end

  create_table "postback_checksums", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "hash"
    t.string "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "rich_menus", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.bigint "folder_id"
    t.string "line_menu_id", comment: "richMenuId"
    t.string "template_id"
    t.string "name"
    t.string "size"
    t.string "title"
    t.string "line_chat_bar_text", comment: "chatBarText"
    t.string "selected"
    t.text "areas", size: :medium
    t.string "status", default: "pending"
    t.boolean "is_active"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["folder_id"], name: "index_rich_menus_on_folder_id"
    t.index ["line_account_id"], name: "index_rich_menus_on_line_account_id"
  end

  create_table "scenario_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "scenario_id"
    t.string "status", default: "disable"
    t.string "name"
    t.text "content", size: :long
    t.string "message_type"
    t.float "priority", default: 999.0
    t.string "delivery_timing"
    t.string "time_designation", default: "00:00"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["scenario_id"], name: "index_scenario_messages_on_scenario_id"
  end

  create_table "scenarios", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.bigint "folder_id"
    t.string "type", default: "normal"
    t.string "title"
    t.string "content"
    t.string "status", default: "disable"
    t.string "delivery_timing_type", default: "now"
    t.string "time_base_type", default: "none"
    t.text "action", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["folder_id"], name: "index_scenarios_on_folder_id"
    t.index ["line_account_id"], name: "index_scenarios_on_line_account_id"
  end

  create_table "survey_customer_answers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.bigint "survey_id"
    t.bigint "survey_question_id"
    t.bigint "survey_customer_id"
    t.text "content", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["line_account_id"], name: "index_survey_customer_answers_on_line_account_id"
    t.index ["survey_customer_id"], name: "index_survey_customer_answers_on_survey_customer_id"
    t.index ["survey_id"], name: "index_survey_customer_answers_on_survey_id"
    t.index ["survey_question_id"], name: "index_survey_customer_answers_on_survey_question_id"
  end

  create_table "survey_customers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "survey_id"
    t.bigint "line_account_id"
    t.integer "answer_num", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["line_account_id"], name: "index_survey_customers_on_line_account_id"
    t.index ["survey_id"], name: "index_survey_customers_on_survey_id"
  end

  create_table "survey_profile_templates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.bigint "folder_id"
    t.string "field_name"
    t.string "description"
    t.string "type"
    t.string "status", default: "enable"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["folder_id"], name: "index_survey_profile_templates_on_folder_id"
    t.index ["line_account_id"], name: "index_survey_profile_templates_on_line_account_id"
  end

  create_table "survey_profiles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.bigint "survey_profile_template_id"
    t.text "content", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["line_account_id"], name: "index_survey_profiles_on_line_account_id"
    t.index ["survey_profile_template_id"], name: "index_survey_profiles_on_survey_profile_template_id"
  end

  create_table "survey_questions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "survey_id"
    t.string "name"
    t.integer "index", default: 0
    t.boolean "is_required", default: false
    t.string "type"
    t.text "content", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id"], name: "index_survey_questions_on_survey_id"
  end

  create_table "surveys", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.bigint "folder_id"
    t.string "code"
    t.string "name"
    t.string "liff_id"
    t.string "title"
    t.text "description"
    t.text "action", size: :long
    t.text "success_message"
    t.string "status", default: "enabled"
    t.boolean "is_publish", default: false
    t.boolean "multiple_answers", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["folder_id"], name: "index_surveys_on_folder_id"
    t.index ["line_account_id"], name: "index_surveys_on_line_account_id"
  end

  create_table "taggings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.bigint "tag_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.bigint "folder_id"
    t.string "type", default: "original"
    t.string "name"
    t.string "description"
    t.string "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["folder_id"], name: "index_tags_on_folder_id"
    t.index ["line_account_id"], name: "index_tags_on_line_account_id"
  end

  create_table "unread_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.bigint "channel_id"
    t.bigint "last_message_id"
    t.integer "total"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["channel_id"], name: "index_unread_messages_on_channel_id"
    t.index ["last_message_id"], name: "index_unread_messages_on_last_message_id"
    t.index ["line_account_id"], name: "index_unread_messages_on_line_account_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "authentication_token"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "auto_response_keywords", "line_accounts"
  add_foreign_key "auto_response_messages", "auto_responses"
  add_foreign_key "auto_responses", "folders"
  add_foreign_key "auto_responses", "line_accounts"
  add_foreign_key "broadcast_messages", "broadcasts"
  add_foreign_key "broadcast_template_messages", "broadcast_templates"
  add_foreign_key "broadcast_templates", "line_accounts"
  add_foreign_key "broadcasts", "line_accounts"
  add_foreign_key "channel_participants", "channels"
  add_foreign_key "channels", "line_accounts"
  add_foreign_key "channels", "line_friends"
  add_foreign_key "flex_message_sent_logs", "flex_messages"
  add_foreign_key "flex_message_sent_logs", "line_accounts"
  add_foreign_key "flex_messages", "line_accounts"
  add_foreign_key "folders", "line_accounts"
  add_foreign_key "line_accounts", "users", column: "owner_id"
  add_foreign_key "line_friends", "line_accounts"
  add_foreign_key "message_templates", "folders"
  add_foreign_key "message_templates", "line_accounts"
  add_foreign_key "messages", "channels"
  add_foreign_key "messages", "line_friends"
  add_foreign_key "rich_menus", "folders"
  add_foreign_key "rich_menus", "line_accounts"
  add_foreign_key "scenario_messages", "scenarios"
  add_foreign_key "scenarios", "folders"
  add_foreign_key "scenarios", "line_accounts"
  add_foreign_key "survey_customer_answers", "line_accounts"
  add_foreign_key "survey_customer_answers", "survey_customers"
  add_foreign_key "survey_customer_answers", "survey_questions"
  add_foreign_key "survey_customer_answers", "surveys"
  add_foreign_key "survey_customers", "line_accounts"
  add_foreign_key "survey_customers", "surveys"
  add_foreign_key "survey_profile_templates", "folders"
  add_foreign_key "survey_profile_templates", "line_accounts"
  add_foreign_key "survey_profiles", "line_accounts"
  add_foreign_key "survey_profiles", "survey_profile_templates"
  add_foreign_key "survey_questions", "surveys"
  add_foreign_key "surveys", "folders"
  add_foreign_key "surveys", "line_accounts"
  add_foreign_key "taggings", "tags"
  add_foreign_key "tags", "folders"
  add_foreign_key "tags", "line_accounts"
  add_foreign_key "unread_messages", "channels"
  add_foreign_key "unread_messages", "line_accounts"
  add_foreign_key "unread_messages", "messages", column: "last_message_id"
end
