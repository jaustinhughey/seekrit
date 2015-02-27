#!/usr/bin/env ruby
require File.expand_path "../bootstrap.rb", __FILE__

use Rack::ShowExceptions unless ENV['RACK_ENV'] == 'production'
use Rack::Session::Cookie, secret: (ENV['SECRET_KEY_BASE'] || SecureRandom.hex(256))
use Rack::Csrf, :raise => true
use Rack::Flash, sweep: true

run SeekritApp
