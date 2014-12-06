class Tweet < ActiveRecord::Base
  default_scope lambda{ order('created_at DESC') }
  scope :created_after, ->(base_time) { where('created_at > ?', base_time) }

  def self.search_color_from_text
    color_dictionary  = Settings.tweet.color.list.to_hash
    color_list        = color_dictionary.keys.map &:to_s
    color_list_regexp = Regexp.union color_list

    tweets     = Tweet.arel_table[:text]
    tweets_sql = tweets.matches "\%#{color_list.first}\%"

    1.upto color_list.length - 1 do |index|
      tweets_sql = tweets_sql.or(tweets.matches "\%#{color_list[index]}\%")
    end

    match_texts = Tweet.where(tweets_sql).pluck(:text)
    match_texts.each do |match_text|
      match = match_text.match color_list_regexp
      return color_dictionary[match[0].to_sym] if match
    end

    Settings.tweet.api.color.default
  end
end
