FactoryBot.define do
  factory :line_account do
    line_user_id {'12sdafsqweeqzcsadvb'}
    line_name {'sample name'}
    display_name {'sample name'}
    channel_id {'qwefgadas2322'}
    channel_secret {'132adaswqewqcz'}
    webhook_url {'http://localhost/webhook/13423423dasd'}
    bot_initialized {true}
  end
end
