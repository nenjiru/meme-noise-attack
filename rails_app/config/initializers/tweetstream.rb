TweetStream.configure do |config|
  config.consumer_key       = YOUR_CONSUMER_KEY
  config.consumer_secret    = YOUR_CONSUMER_SECRET
  config.oauth_token        = YOUR_ACCESS_TOKEN
  config.oauth_token_secret = YOUR_ACCESS_TOKEN_SECRET
  config.auth_method        = :oauth
end
