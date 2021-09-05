# frozen_string_literal: true

module User::ScenarioMessagesHelper
  def schedule_date_for(scenario, message)
    if scenario.mode_date?
      message.is_initial? || message.date == 0 ? '開始直後' : ''
    else
      message.is_initial? || message.date == 0 ? '開始当日' : "#{message.date}日後"
    end
  end

  def schedule_time_for(scenario, message)
    if scenario.mode_date?
      if message.is_initial?
        "#{message.order}通目"
      else
        sb = message.date > 0 ? "#{message.date}日" : ''
        sb + "#{message.time&.to_time.strftime('%-H時間%-M分')}後 #{message.order}通目"
      end
    else
      "#{message.time} #{message.order}通目"
    end
  end
end
