require "rubygems"
require "rack/csrf"
require "sinatra/base"
require "fileutils"
require "redis"
require "rack-flash"
require "sinatra/param"
require_relative "app.rb"

# Get all stuff under lib recursively
Dir.glob(File.join(FileUtils.pwd, 'lib', '**', '*.rb')).each { |f| require f }

# Designate runlevel
unless ENV['RACK_ENV'] && ENV['RACK_ENV'].length > 0
  ENV['RACK_ENV'] = "development"
end

# For dev/test usage of Pry
unless ENV['RACK_ENV'] == ('production' || 'staging')
  require "pry"
end
