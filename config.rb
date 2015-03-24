require 'sinatra/base'

if Sinatra::Base.environment == :development
	require 'dotenv'
	require 'awesome_print'
	Dotenv.load
end

require "./db/db_init"
Dir["./helpers/**/*.rb"].each { |f| require f }
Dir["./controllers/**/*.rb"].each { |f| require f }
Dir["./models/**/*.rb"].each { |f| require f }
