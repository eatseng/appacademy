require 'active_support/core_ext/object/try'
require 'active_support/inflector'
require_relative './db_connection.rb'

#require_relative './sql_object.rb'

class AssocParams
  def other_class


  end

  def other_table
  end
end

class BelongsToAssocParams < AssocParams

  attr_reader :other_class_name, :primary_key, :foreign_key, :other_class, :other_table_name

  def initialize(name, params)
    options = {
      other_class_name: nil,
      primary_key: "id",
      foreign_key: "#{name}_id"
    }.merge(params)

    @other_class_name = name.to_s.camelize if options[:other_class_name].nil?
    @primary_key = options[:primary_key]
    @foreign_key = options[:foreign_key]
  end

  def other_class_table_name
    @other_class = @other_class_name.constantize
    @other_table_name = @other_class.table_name
  end

  def type
  end
end

class HasManyAssocParams < AssocParams

  attr_reader :other_class_name, :primary_key, :foreign_key, :other_class, :other_table_name

  def initialize(name, params, self_class)
    options = {
      other_class_name: nil,
      primary_key: "id",
      foreign_key: "#{self_class.to_s.foreign_key}_id"
    }.merge(params)

    @other_class_name = name.to_s.singularize.camelize if options[:other_class_name].nil?
    @primary_key = options[:primary_key]
    @foreign_key = options[:foreign_key]
  end

  def other_class_table_name
    @other_class = @other_class_name.constantize
    @other_table_name = @other_class.table_name
  end

  def type
  end
end

module Associatable

  attr_reader :assoc_params

  def assoc_params
    @assoc_params
  end

  def belongs_to(name, params = {})
    attributes = BelongsToAssocParams.new(name, params)
    @assoc_params = {} if @assoc_params.nil?
    @assoc_params[name] = attributes
    self.send(:define_method, name.to_sym) do
      object = DBConnection.execute(<<-SQL)
          SELECT
            *
          FROM
            #{attributes.other_class_table_name}
          WHERE
            #{attributes.other_class_table_name}.#{attributes.primary_key} =    #{send(attributes.foreign_key)}
          SQL
      attributes.other_class.parse_all(object).first
    end
  end

  def has_many(name, params = {})
    attributes = HasManyAssocParams.new(name, params, self.class)
    self.send(:define_method, name.to_sym) do
      object = DBConnection.execute(<<-SQL)
          SELECT
            *
          FROM
            #{attributes.other_class_table_name}
          WHERE
            #{attributes.foreign_key} = #{send(attributes.primary_key)}
          SQL
      attributes.other_class.parse_all(object)
    end
  end

  def has_one_through(name, assoc1, assoc2)
    #p @assoc_params[assoc1].other_class_table_name
    int_foreign_key = "#{assoc2.to_s}_id"
    source_primary_key = "#{assoc2.to_s.pluralize}.id"


    self.send(:define_method, name.to_sym) do
      object = DBConnection.execute(<<-SQL)
          SELECT
            #{assoc2.to_s.pluralize}.*
          FROM
            #{self.class.assoc_params[assoc1].other_class_table_name}
          JOIN
            #{assoc2.to_s.camelize.constantize.table_name}
          ON
            #{self.class.assoc_params[assoc1].other_class_table_name}.#{int_foreign_key} = #{source_primary_key}
          WHERE
            #{self.class.assoc_params[assoc1].other_class_table_name}.#{self.class.assoc_params[assoc1].primary_key} =    #{send(self.class.assoc_params[assoc1].foreign_key)}
          SQL
      assoc2.to_s.camelize.constantize.parse_all(object).first
    end
  end
end
