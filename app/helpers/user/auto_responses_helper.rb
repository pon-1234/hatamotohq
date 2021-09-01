# frozen_string_literal: true

module User::AutoResponsesHelper
  def build_auto_response(params)
    auto_response = AutoResponse.new
    auto_response.line_account = Current.user.line_account
    auto_response.folder_id = params[:folder_id]
    auto_response.name = params[:name]
    auto_response.status = params[:status]
    auto_response
  end

  def build_auto_response_keywords(auto_response, keywords)
    auto_response.auto_response_keywords.destroy_all
    keywords.each do |keyword|
      AutoResponseKeyword.create!(auto_response: auto_response, keyword: keyword)
    end
  end

  def build_auto_response_messages(auto_response, messages_params)
    # Delete old messages before adding new one
    # TODO should update message if existing
    auto_response.auto_response_messages.destroy_all
    # Insert new message
    messages_params.each do |message_params|
      message = AutoResponseMessage.new(message_params)
      message.auto_response = auto_response
      message.save!
    end
  end
end
