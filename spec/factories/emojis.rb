FactoryBot.define do
  factory :emoji do
    sequence :line_emoji_id, (52002734..52002773).to_a.cycle
    package_id {11537}
  end
end
