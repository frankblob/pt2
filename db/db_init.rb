require 'sequel'
require 'logger'
require 'shield'

Sequel.default_timezone = :utc
Sequel::Model.plugin :timestamps, :update_on_create=>true
Sequel::Model.plugin :validation_helpers

DB = Sequel.connect(ENV['DATABASE_URL'], loggers: [Logger.new($stdout)])
require_relative 'createdb.rb' unless DB.table_exists?(:users)

require 'que'
Que.connection = DB
Que.migrate! unless DB.table_exists?(:que_jobs)

#uncomment to auto-sync models with DB contraints
#Sequel::Model.plugin(:constraint_validations) 
#Sequel::Model.plugin(:auto_validations)