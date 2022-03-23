# frozen_string_literal: true

class Postback::SendScenarioHandler < Postback::BaseHandler
  def perform
    scenario_id = @content['scenario_id']
    ScenarioSchedulerJob.perform_later(@friend.channel.id, scenario_id)
  end
end
