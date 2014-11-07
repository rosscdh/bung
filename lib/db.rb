require "sequel"
require "rubygems"
require 'sequel-json'


DB = Sequel.connect(ENV['DATABASE_URL'])

class Bung < Sequel::Model(:bung)
  plugin :serialization
  serialize_attributes :json, :profile
end

unless DB.table_exists?(:bung)
  DB.create_table :bung do
    primary_key :id, "uuid"
    column :profile, "text", :default=>"{}"
  end
  Bung.columns # load columns
end
