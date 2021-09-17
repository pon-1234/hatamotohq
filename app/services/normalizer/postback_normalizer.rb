# frozen_string_literal: true

class Normalizer::PostbackNormalizer
  def initialize(content)
    @content = content
  end

  def perform
    @content.extend Hashie::Extensions::DeepLocate
    # Find all postback action
    actions = @content.deep_locate -> (key, value, object) { key.eql?('type') && value.eql?('postback') }
    actions.each do |action|
      # Line API limit postback data's length to 300 character
      # we have to cache the postback data in database and restore it
      # when receiving postback event
      hash = Digest::MD5.hexdigest action['data'].to_json
      PostbackMapper.create(key: hash, value: action['data'])
      action['data'] = hash
    end
    @content
  end
end
