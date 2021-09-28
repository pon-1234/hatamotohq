class MessageFinder
  def initialize(channel, params)
    @channel = channel
    @params = params
  end

  def perform
    current_messages
  end

  private

  def channel_messages
    @channel.messages.includes([:sender])
  end

  def messages
    channel_messages
  end

  def current_messages
    if @params[:before].present?
      messages.reorder('created_at desc').where('id < ?', @params[:before]).limit(20).reverse
    else
      messages.reorder('created_at desc').limit(20).reverse
    end
  end
end
