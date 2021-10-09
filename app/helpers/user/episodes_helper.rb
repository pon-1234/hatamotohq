module User::EpisodesHelper
  def build_episode(params)
    episode = Episode.new(params)
    episode
  end
end
