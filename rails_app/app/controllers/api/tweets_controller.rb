class Api::TweetsController < Api::BaseController
  def length
    success_handler({
        length: Tweet.all.length})
  end

  def stream
    limit = Settings.tweet.api.stream.limit

    if params[:base_time]
      tweets = Tweet.created_after params[:base_time]
      tweets = tweets.limit limit if tweets.count > limit
    else
      tweets = Tweet.limit limit
    end

    success_handler({
        tweets: tweets.reverse})
  end

  def color
    success_handler({
        color: Tweet.search_color_from_text})
  end
end
