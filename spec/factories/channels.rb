FactoryBot.define do
  factory :channel do
    title {'sample title'}
    last_message {'hello'}
    last_activity_at {1.hour.ago}
    last_seen_at {5.minutes.ago}
  end
end
