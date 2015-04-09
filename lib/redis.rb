require "rubygems"
require "redis"

# Figure out where Redis is.
if ENV['REDIS_HOST'] && ENV['REDIS_HOST'].length > 0
  REDIS_HOST = ENV['REDIS_HOST']
else
  REDIS_HOST = 'localhost'
end

if ENV['REDIS_PORT'] && ENV['REDIS_PORT'].length > 0
  REDIS_PORT = ENV['REDIS_PORT']
else
  REDIS_PORT = '6379'
end

$redis = Redis.new(host: REDIS_HOST, port: REDIS_PORT)
