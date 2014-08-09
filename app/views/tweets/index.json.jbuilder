json.array!(@tweets) do |tweet|
  json.extract! tweet, :id, :user, :tweet
  json.url tweet_url(tweet, format: :json)
end
