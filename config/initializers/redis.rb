if Rails.env.production?
  $redis = Redis.new(url: ENV["REDIS_URL"])
else
  # Set the Redis store to an object
  $redis = Redis.new(host: 'localhost', port: 6379)
end
