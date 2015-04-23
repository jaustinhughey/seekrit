class SeekritApp < Sinatra::Base
  register Sinatra::Namespace
  helpers Sinatra::Param
  helpers do
    # Is this request authenticated?
    def authenticated?
      key = env["HTTP_X_SEEKRIT_KEY"]
      if key && ($redis.get("seekrit_api_key") == key)
        return true
      end
      return false
    end
  end

  namespace "/api" do
    # Everything should be JSON, and should be authenticated via api key header
    before do
      if authenticated?
        content_type :json
      else
        halt 403, {error: "not authenticated"}.to_json
      end
    end

    get '/' do
      # Just return an empty hash to allow some sanity
      body ({}).to_json
    end

    get '/get/all' do
      # Basic index
      body (Secret.all).to_json
    end

    get '/get/:key' do
      # Retrieve specific key from redis hash
      body ({params[:key].to_sym => Secret.get(params[:key])}).to_json
    end

    post '/new' do
      # Create a new key/value combo
      # Takes POST data with a secret name and a value for it
      # For example: github_api_key, abc123xyz...

      if params[:secret] && params[:value]
        s = Secret.new(name: params[:secret], value: params[:value])
        if s.save
          body ({status: "OK"}).to_json
        else
          halt 500, ({error: "could not save #{params[:secret]}"}).to_json
        end
      else
        halt 400, ({error: "bad request; missing secret and/or value"}).to_json
      end
    end

    delete '/:name' do
      # Remove the specified key
      if Secret.destroy(params[:name])
        body ({status: "OK"}).to_json
      else
        body ({error: "could not remove #{params[:name]}"}).to_json
      end
    end
  end
end
