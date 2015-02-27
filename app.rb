class SeekritApp < Sinatra::Base
  helpers Sinatra::Param
  helpers do
    # TODO: Helpers here
  end

  get '/' do
    # Basic index
    erb :index
  end

  get '/secrets' do
    # Show all the secrets
    @secrets = Secret.all
  end

  

  # TODO: Authentication
  # TODO: Show vars
  # TODO: Update var
  # TODO: Add var
  # TODO: Info page (redis IP, num keys, connect info etc.)

end
