require "rubygems"
require "redis"

$redis = Redis.new # Automatically connects to localhost; DO NOT want to run
                   # this app on a non-redis host because it's not built
                   # for large-scale use INTENTIONALLY.
                   # See the application's readme.md for more info on security.
