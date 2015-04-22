ENV['RACK_ENV'] = 'test'
require_relative("../bootstrap.rb")
require 'minitest/autorun'
require 'rack/test'
require 'securerandom'
require "pry"
require_relative("../app.rb")
