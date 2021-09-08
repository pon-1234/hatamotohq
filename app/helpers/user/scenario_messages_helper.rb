# frozen_string_literal: true

module User::ScenarioMessagesHelper
  def schedule_date_for(scenario, message)
    if scenario.elapsed_time_mode?
      message.is_initial? || message.date == 0 ? '開始直後' : ''
    elsif scenario.time_mode?
      message.is_initial? || message.date == 0 ? '開始当日' : "#{message.date}日後"
    end
  end

  def schedule_time_for(scenario, message)
    if scenario.elapsed_time_mode?
      if message.is_initial?
        "#{message.order}通目"
      else
        sb = message.date > 0 ? "#{message.date}日と" : ''
        sb + "#{message.time&.to_time.strftime('%-H時間%-M分')}後 #{message.order}通目"
      end
    elsif scenario.time_mode?
      "#{message.time} #{message.order}通目"
    end
  end
end
