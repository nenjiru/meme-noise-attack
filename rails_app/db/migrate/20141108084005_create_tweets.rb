class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string   :text
      t.string   :profile_image_url
      t.string   :screen_name
      t.string   :name
      t.datetime :created_at
    end
  end
end
