require_relative './db_connection'

module Searchable
  # takes a hash like { :attr_name => :search_val1, :attr_name2 => :search_val2 }
  # map the keys of params to an array of  "#{key} = ?" to go in WHERE clause.
  # Hash#values will be helpful here.
  # returns an array of objects
  def where(params)
    keys = params.map { |key, value| "#{key} = ?" }
    values = params.map { |key, value| "#{value}" }

    object = DBConnection.execute(<<-SQL, *values)
        SELECT
          *
        FROM
          #{self.table_name}
        WHERE
         (#{keys.join(" AND ")})
        SQL
    self.parse_all(object)
  end
end