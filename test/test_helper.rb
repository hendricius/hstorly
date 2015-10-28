$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'


require 'rubygems'
require 'active_support'
require 'active_record'
require 'pry'
require 'hstorly'

ActiveRecord::Base.logger = Logger.new(nil)
ActiveRecord::Base.establish_connection(:adapter => "postgresql", :host=>'127.0.0.1', :user=>'postgres')
begin
ActiveRecord::Base.connection.execute('CREATE DATABASE "multilang-hstore-test" WITH OWNER postgres;')
rescue ActiveRecord::StatementInvalid
  puts "Database already exists"
end
ActiveRecord::Base.establish_connection(:adapter => "postgresql", :database => "multilang-hstore-test", :host=>'127.0.0.1', :user=>'postgres')
ActiveRecord::Base.connection.execute('CREATE EXTENSION IF NOT EXISTS hstore;')

I18n.enforce_available_locales = false
I18n.available_locales = [:en, :de]
I18n.locale = I18n.default_locale = :de

def setup_db
  ActiveRecord::Migration.verbose = false
  load "schema.rb"
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

#testable models
class AbstractPost < ActiveRecord::Base
end

class TestPost < ActiveRecord::Base
  self.table_name = 'abstract_posts'
  hstore_translate :title
end
