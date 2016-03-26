require 'active_support'
require 'active_support/core_ext'
require 'active_record'

namespace :model_from_schema do
  desc 'Generate model files from db schema'

  task :gen do
    module ModelGenerator
      Models = {}

      module_function

      def create_table(table_name, *)
        Models[table_name.classify] = {
          has_many: [],
          belongs_to: [],
        }
      end

      # 無視
      def add_index(*) end
      def add_foreign_key(from, to)
        fromc, toc = from.classify, to.classify
        Models[fromc][:belongs_to].push to.singularize
        Models[toc][:has_many].push from
      end

      def schema_load(file)
        eval File.read(file)
      end

      def save
        Models.each do |klass, data|
          code = [
            "class #{klass} < ActiveRecord::Base",
            data[:has_many].map{|x| "  has_many :#{x}"},
            data[:belongs_to].map{|x| "  belongs_to :#{x}"},
            "end\n",
          ].flatten.join("\n")
          path = File.join('app', 'models', "#{klass.underscore}.rb")

          File.write(path, code)
        end
      end
    end

    ModelGenerator.schema_load("Schemafile")
    ModelGenerator.save
  end
end
