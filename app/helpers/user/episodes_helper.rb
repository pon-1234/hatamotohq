# frozen_string_literal: true

module User::EpisodesHelper
  def build_episode(params)
    episode = Episode.new(params)
    episode
  end
end
