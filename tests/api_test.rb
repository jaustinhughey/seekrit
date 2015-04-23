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
      tdata[SecureRandom.uuid] = SecureRandom.uuid
    end

    tdata.each do |k, v|
      post '/api/new', {secret: k, value: v}
    end

    # Do the get request now and it should have the same stuff
    # as tdata
    get '/api/get/all'
    res = JSON.parse(last_response.body)
    tdata.each do |k, v|
      assert_equal res[k], v
    end
  end

  def test_set_new_seekrit
    # POST /api/new
    # Should set a new key
    k = SecureRandom.uuid
    v = SecureRandom.uuid

    post '/api/new', { secret: k, value: v }
    assert_equal ({'status' => 'OK'}), JSON.parse(last_response.body)
  end

  def test_get_single_key_val
    # GET /keyname
    # Should return JSON like: { "key": "value" }
    # Create new key/value with API
    k = SecureRandom.uuid
    v = SecureRandom.uuid
    post '/api/new', {secret: k, value: v}

    # Perform GET request
    get "/api/get/#{k}"
    assert_equal ({k => v}), (JSON.parse(last_response.body))
  end

  def test_delete_key
    # Create a bogus key with a bogus value to test against
    k = SecureRandom.uuid
    v = SecureRandom.uuid
    post '/api/new', {secret: k, value: v}

    # Delete said key
    delete "/api/destroy/#{k}"
    assert_equal ({"status" => "OK"}), (JSON.parse(last_response.body))

    # Test that it's ACTUALLY gone
    get "/api/get/#{k}"
    assert_equal ({k => nil}), (JSON.parse(last_response.body))

  end
end
