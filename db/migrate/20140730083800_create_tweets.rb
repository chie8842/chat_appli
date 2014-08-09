class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :userId
      t.string :userName
      t.string :tweet

      t.timestamps
    end
  end
end
