require "rubygems"
require "sinatra/base"
require "sinatra/namespace"
require "sinatra/param"
require "fileutils"
require "redis"
require "json"
require "virtus"
require_relative "app.rb"

# Designate runlevel
if ENV['RACK_ENV'] && ENV['RACK_ENV'].length > 0
  RUNTIME_ENV = ENV['RACK_ENV']
else
  RUNTIME_ENV = "development"
end

# Get all stuff under lib recursively
Dir.glob(File.join(FileUtils.pwd, 'lib', '**', '*.rb')).each { |f| require f }

# ...and all the models too
Dir.glob(File.join(FileUtils.pwd, 'models', '**', '*.rb')).each { |f| require f }

# For dev/test usage of Pry
if RUNTIME_ENV == ('development' || 'test')
  require "pry"
end
