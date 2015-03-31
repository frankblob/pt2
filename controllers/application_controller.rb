class ApplicationController < Sinatra::Base
  helpers ApplicationHelper
  helpers Shield::Helpers

  configure do
    require 'encrypted_cookie'
    
    cookie_config = {        
      :key          => 'usr',
      :path         => "/",
      :expire_after => 86400, # one day in seconds
      :secret       => ENV["COOKIE_KEY"], 
      :httponly     => true
      }
    
    if production?
      cookie_config.merge!( :secure => true )
      require 'rack/ssl-enforcer'
      use Rack::SslEnforcer
    end
    
    use Rack::Session::EncryptedCookie, cookie_config
    use Shield::Middleware, "/login"

    enable :logging, :method_override
    set :root, File.expand_path("../../", __FILE__)
  end

  get '/' do
    erb :index
  end

  get '/noway' do
    error(401) unless authenticated(User)
    erb :app_noway
  end  

  get '/login' do
    erb :login
  end

  post "/login" do
    if login(User, params[:login], params[:password])
      remember(authenticated(User)) if params[:remember_me]
      redirect to params[:redirect] || "/"
    else
      redirect "/login"
    end
  end

  get '/signup' do
    erb :signup
  end

  post '/signup' do
    if user = User.create(params[:user])
      redirect "/"
    else
      redirect "/signup"
    end
  end

  get "/logout" do
    logout(User)
    redirect "/"
  end

  not_found do
    status 404
    erb :not_found
  end
  
end
