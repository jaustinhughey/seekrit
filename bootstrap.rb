require "rubygems"
require "rack/csrf"
require "sinatra/base"
require "fileutils"
require "redis"
require "rack-flash"
require "sinatra/param"
require "json"
require_relative "app.rb"

# Designate runlevel
unless ENV['RACK_ENV'] && ENV['RACK_ENV'].length > 0
  ENV['RACK_ENV'] = "development"
end

# Get all stuff under lib recursively
Dir.glob(File.join(FileUtils.pwd, 'lib', '**', '*.rb')).each { |f| require f }

# For dev/test usage of Pry
unless ENV['RACK_ENV'] == ('production' || 'staging')
  require "pry"
end
