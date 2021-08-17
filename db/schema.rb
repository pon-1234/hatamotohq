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

ActiveRecord::Schema.define(version: 2021_08_17_064233) do

  create_table "action_objects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.json "format"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

  create_table "basic_settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.string "company_name"
    t.string "address"
    t.json "business_hours"
    t.string "phone_number"
    t.string "website"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["line_account_id"], name: "index_basic_settings_on_line_account_id"
  end

  create_table "channel_participants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "channel_id"
    t.bigint "line_customer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["channel_id"], name: "index_channel_participants_on_channel_id"
    t.index ["line_customer_id"], name: "index_channel_participants_on_line_customer_id"
  end

  create_table "channels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_friend_id"
    t.string "title"
    t.string "avatar"
    t.text "last_message"
    t.string "status", default: "1"
    t.string "alias"
    t.datetime "last_message_at"
    t.string "slug"
    t.boolean "un_read", default: true
    t.boolean "is_mute", default: false
    t.boolean "is_pair_chat", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
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
    t.bigint "line_customer_id"
    t.string "_uid"
    t.string "username"
    t.string "password"
    t.string "role", default: "admin"
    t.string "status", default: "inactive"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["line_customer_id"], name: "index_line_accounts_on_line_customer_id"
  end

  create_table "line_customers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "line_picture_url"
    t.string "line_user_id"
    t.string "line_name"
    t.string "display_name"
    t.text "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
  end

  create_table "line_friends", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.bigint "line_customer_id"
    t.date "birthday"
    t.string "area"
    t.string "gender"
    t.string "prefecture"
    t.string "status"
    t.string "status_from_bot", default: "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["line_account_id"], name: "index_line_friends_on_line_account_id"
    t.index ["line_customer_id"], name: "index_line_friends_on_line_customer_id"
  end

  create_table "line_settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.string "client_id"
    t.string "channel_access_token"
    t.string "channel_secret"
    t.string "invite_url"
    t.string "webhook_url"
    t.string "liff_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["line_account_id"], name: "index_line_settings_on_line_account_id"
  end

  create_table "message_content_distributions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "message_distribution_id"
    t.text "content", size: :long
    t.string "message_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["message_distribution_id"], name: "index_message_content_distributions_on_message_distribution_id"
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

  create_table "message_distributions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "line_account_id"
    t.text "conditions"
    t.string "title"
    t.string "date_start"
    t.boolean "deliver_now", default: true
    t.string "status"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["line_account_id"], name: "index_message_distributions_on_line_account_id"
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
    t.bigint "line_customer_id"
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
    t.index ["line_customer_id"], name: "index_messages_on_line_customer_id"
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
    t.bigint "line_customer_id"
    t.bigint "survey_id"
    t.bigint "survey_question_id"
    t.bigint "survey_customer_id"
    t.text "content", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["line_customer_id"], name: "index_survey_customer_answers_on_line_customer_id"
    t.index ["survey_customer_id"], name: "index_survey_customer_answers_on_survey_customer_id"
    t.index ["survey_id"], name: "index_survey_customer_answers_on_survey_id"
    t.index ["survey_question_id"], name: "index_survey_customer_answers_on_survey_question_id"
  end

  create_table "survey_customers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "survey_id"
    t.bigint "line_customer_id"
    t.integer "answer_num", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["line_customer_id"], name: "index_survey_customers_on_line_customer_id"
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
    t.bigint "line_customer_id"
    t.bigint "survey_profile_template_id"
    t.text "content", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["line_customer_id"], name: "index_survey_profiles_on_line_customer_id"
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

  create_table "taggables", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.bigint "tag_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["tag_id"], name: "index_taggables_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggables_on_taggable_type_and_taggable_id"
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
    t.bigint "line_customer_id"
    t.bigint "channel_id"
    t.bigint "last_message_id"
    t.integer "total"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["channel_id"], name: "index_unread_messages_on_channel_id"
    t.index ["last_message_id"], name: "index_unread_messages_on_last_message_id"
    t.index ["line_customer_id"], name: "index_unread_messages_on_line_customer_id"
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

  add_foreign_key "auto_response_keywords", "line_accounts"
  add_foreign_key "auto_response_messages", "auto_responses"
  add_foreign_key "auto_responses", "folders"
  add_foreign_key "auto_responses", "line_accounts"
  add_foreign_key "basic_settings", "line_accounts"
  add_foreign_key "channel_participants", "channels"
  add_foreign_key "channel_participants", "line_customers"
  add_foreign_key "channels", "line_friends"
  add_foreign_key "flex_message_sent_logs", "flex_messages"
  add_foreign_key "flex_message_sent_logs", "line_accounts"
  add_foreign_key "flex_messages", "line_accounts"
  add_foreign_key "folders", "line_accounts"
  add_foreign_key "line_accounts", "line_customers"
  add_foreign_key "line_friends", "line_accounts"
  add_foreign_key "line_friends", "line_customers"
  add_foreign_key "line_settings", "line_accounts"
  add_foreign_key "message_content_distributions", "message_distributions"
  add_foreign_key "message_distributions", "line_accounts"
  add_foreign_key "message_templates", "folders"
  add_foreign_key "message_templates", "line_accounts"
  add_foreign_key "messages", "channels"
  add_foreign_key "messages", "line_customers"
  add_foreign_key "rich_menus", "folders"
  add_foreign_key "rich_menus", "line_accounts"
  add_foreign_key "scenario_messages", "scenarios"
  add_foreign_key "scenarios", "folders"
  add_foreign_key "scenarios", "line_accounts"
  add_foreign_key "survey_customer_answers", "line_customers"
  add_foreign_key "survey_customer_answers", "survey_customers"
  add_foreign_key "survey_customer_answers", "survey_questions"
  add_foreign_key "survey_customer_answers", "surveys"
  add_foreign_key "survey_customers", "line_customers"
  add_foreign_key "survey_customers", "surveys"
  add_foreign_key "survey_profile_templates", "folders"
  add_foreign_key "survey_profile_templates", "line_accounts"
  add_foreign_key "survey_profiles", "line_customers"
  add_foreign_key "survey_profiles", "survey_profile_templates"
  add_foreign_key "survey_questions", "surveys"
  add_foreign_key "surveys", "folders"
  add_foreign_key "surveys", "line_accounts"
  add_foreign_key "taggables", "tags"
  add_foreign_key "tags", "folders"
  add_foreign_key "tags", "line_accounts"
  add_foreign_key "unread_messages", "channels"
  add_foreign_key "unread_messages", "line_customers"
  add_foreign_key "unread_messages", "messages", column: "last_message_id"
end
