require File.join Rails.root, 'config', 'environment.rb'

daemon = TweetStream::Daemon.new('twitter_streaming',:log_output => true,:dir => File.join(Rails.root, 'tmp', 'pids'))

daemon.on_inited do
  Rails.logger = ActiveRecord::Base.logger = Logger.new(File.join(Rails.root, 'log', 'stream.log'))
end

search_hashtag = Settings.tweet.stream.search_hashtag

daemon.track(search_hashtag) do |tweet|
  Tweet.create!(
    :text              => tweet.text.gsub(/\n/,' '),
    :profile_image_url => tweet.user.profile_image_url.to_s,
    :screen_name       => tweet.user.screen_name,
    :name              => tweet.user.name,
    :created_at        => tweet.created_at
    )

  Rails.logger.debug tweet.text
end
