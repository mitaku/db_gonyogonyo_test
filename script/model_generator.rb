require 'active_support'
require 'active_support/core_ext'
require 'active_record'

class ModelGenerator
  attr_reader :models

  def initialize
    @models = {}
  end

  def create_table(table_name, *)
    models[table_name.classify] = {
      has_many: [],
      belongs_to: [],
    }
  end

  # 無視
  def add_index(*) end

  def add_foreign_key(from, to)
    fromc, toc = from.classify, to.classify
    models[fromc][:belongs_to].push to.singularize
    models[toc][:has_many].push from
  end

  def schema_load(file)
    eval File.read(file)
  end

  def save
    models.each do |klass, data|
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

gen = ModelGenerator.new
gen.schema_load("Schemafile")
gen.save
