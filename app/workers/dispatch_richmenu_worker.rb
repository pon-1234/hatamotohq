# frozen_string_literal: true

class DispatchRichmenuWorker
  include Sidekiq::Worker

  def perform(*args)
    RichMenu.enabled.each do |menu|
      DispatchRichMenuJob.perform_later(menu.id)
    end
  end
end
