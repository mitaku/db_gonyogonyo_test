require 'active_record'
require 'mysql2'
require 'yaml'

conf = YAML.load_file('./config/database.yml')

# 単数形のテーブルだった
ActiveRecord::Base.pluralize_table_names = false
ActiveRecord::Base.establish_connection(conf['development'])

# updated_at扱いのカラムがmodified_atだった
module ActiveRecord
  module Timestamp
    def timestamp_attributes_for_update
      [:updated_at, :modified_at]
    end

    def timestamp_attributes_for_create
      [:created_at]
    end
  end
end

Dir.glob("app/models/*.rb").each do |f|
  require_relative f
end
