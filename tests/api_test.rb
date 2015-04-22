require_relative("test_helper.rb")

class ApiTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  # Set up a global api key to be used
  API_KEY = SecureRandom.uuid

  def app
    SeekritApp
  end

  def setup
    # Wipe Redis seekrit keyspace for tests
    $redis.del(Secret::SECRET_KEY)

    # Put the fake API key in Redis for requests
    $redis.set("seekrit_api_key", API_KEY)

    # Specify all subsequent headers for tests
    header "X-Seekrit-Key", API_KEY
  end

  def test_root_empty
    # First fetch should be empty
    get '/api/'
    assert_equal JSON.parse(last_response.body), {}
  end

  def test_all_route
    # GET /all should have a valid JSON hash returned
    # with ALL the keys/values in it.

    # Start by creating some keys/values
    tdata = {}
    3.times do
      tdata[SecureRandom.uuid.to_sym] = SecureRandom.uuid
    end

    tdata.each do |k, v|
      post '/api/new', {secret: k.to_s, value: v.to_s}
    end

    # Do the get request now and it should have the same stuff
    # as tdata
    get '/api/get/all'
    res = JSON.parse(last_response.body)
    tdata.each do |k, v|
      assert_equal res[k.to_s], v
    end
  end

  def test_set_new_seekrit
    # POST /
    # Should set a new key
    #
    # Fetch the main key from Redis directly
    # TODO
    #
    # Ensure that the key just set is in there with the correct value
    # TODO
  end

  def test_get_single_key_val
    # GET /keyname
    # Should return JSON like: { "key": "value" }
    # TODO: Inject new key into redis directly
    # TODO: GET /keyname
    # TODO: Parse response into hash from JSON
    # TODO: Check that the key exists in the hash
    # TODO: Check that the value is correct for that key
  end

private

  def headers
    {"X-Seekrit-Key" => API_KEY, "accept" => "text/json", "content-type" => "text/json"}
  end
end




# class MyTest < MiniTest::Unit::TestCase
#
#   include Rack::Test::Methods
#
#   def app
#     Sinatra::Application
#   end
#
#   def test_hello_world
#     get '/'
#     assert last_response.ok?
#     assert_equal "Hello, World!", last_response.body
#   end
# end
