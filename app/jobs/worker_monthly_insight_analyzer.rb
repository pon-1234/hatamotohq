# frozen_string_literal: true

class WorkerMonthlyInsightAnalyzer
  include Sidekiq::Worker

  def perform(*args)
    LineAccount.all.each do |line_account|
      insights = Insight.belongs_to_account(line_account).this_month
      monthly_insight = Insight.new(line_account: line_account, type: :monthly)
      monthly_insight.date = Time.zone.now.beginning_of_month
      monthly_insight.broadcast = insights.pluck(:broadcast).compact.sum
      monthly_insight.api_push = insights.pluck(:api_push).compact.sum
      monthly_insight.save!
    end
  end
end
