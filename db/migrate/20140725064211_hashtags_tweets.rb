class HashtagsTweets < ActiveRecord::Migration
  def change
    create_table :hashtags_tweets do |t|
      t.integer :hashtag_id
      t.integer :tweet_id
    end
  end
end
