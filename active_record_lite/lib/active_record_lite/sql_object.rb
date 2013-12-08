require_relative './associatable'
require_relative './db_connection' # use DBConnection.execute freely here.
require_relative './mass_object'
require_relative './searchable'
require 'active_support/inflector'

class SQLObject < MassObject
  extend Searchable
  extend Associatable
  # sets the table_name
  def self.set_table_name(table_name)
    @table_name = table_name
  end

  # gets the table_name
  def self.table_name
    class_name = self.to_s
    return class_name.underscore.pluralize if @table_name.nil?
    @table_name
  end

  # querys database for all records for this type. (result is array of hashes)
  # converts resulting array of hashes to an array of objects by calling ::new
  # for each row in the result. (might want to call #to_sym on keys)
  def self.all
    objects = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      SQL

    objects.map { |object| self.new(object) }
  end

  # querys database for record of this type with id passed.
  # returns either a single object or nil.
  def self.find(id)
    object = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{table_name}.id = #{id}
      SQL
    return nil if object.empty?
    self.new(object.first)
  end

  # executes query that creates record in db with objects attribute values.
  # use send and map to get instance values.
  # after, update the id attribute with the helper method from db_connection
  def create
    attributes = self.class.attributes.map { |attribute| attribute.to_s }
    attributes.shift
    question_marks = []
    attributes.each { |attribute| question_marks << "?"}

    DBConnection.execute(<<-SQL, *attribute_values(attributes))
        INSERT INTO
          #{self.class.table_name} (#{attributes.join(", ")})
        VALUES
          (#{question_marks.join(", ")})
        SQL
    #self.send('id', DBConnection.instance.last_insert_row_id)
  end

  # executes query that updates the row in the db corresponding to this instance
  # of the class. use "#{attr_name} = ?" and join with ', ' for set string.
  def update
    attributes = self.class.attributes.map { |attribute| attribute.to_s }
    attributes.shift
    question_marks = []
    attributes.each do |attribute|
       question_marks << "#{attribute} = ?"
    end

    DBConnection.execute(<<-SQL, *attribute_values(attributes))
        UPDATE
          #{self.class.table_name}
        SET
          #{question_marks.join(", ")}
        WHERE
          id = #{self.send('id')}
        SQL
    #self.send('id', SchoolDatabase.instance.last_insert_row_id)
  end

  # call either create or update depending if id is nil.
  def save
    if self.send('id').nil?
      self.create
    else
      self.update
    end
  end

  # helper method to return values of the attributes.
  def attribute_values(attributes)
     attributes.map { |attribute| self.send(attribute) }
  end
end




cats_db_file_name =
  File.expand_path(File.join(File.dirname(__FILE__), "../../test/cats.db"))
DBConnection.open(cats_db_file_name)

class House < SQLObject
  set_table_name("houses")
  my_attr_accessible(:id, :address, :house_id)
end

class Human < SQLObject
  set_table_name("humans")
  my_attr_accessible(:id, :fname, :lname, :house_id)

  has_many :cats, :foreign_key => :owner_id
  belongs_to :house
end

class Cat < SQLObject
  set_table_name("cats")
  my_attr_accessible(:id, :name, :owner_id)

  belongs_to :human, :class_name => "Human", :primary_key => :id, :foreign_key => :owner_id
  has_one_through :house, :human, :house
end




cat = Cat.find(1)
human = Human.find(1)
#human.house
#human.cats
cat.house
