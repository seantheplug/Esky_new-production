class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  ActiveRecord::Base.class_eval do
    def self.where_not(opts)
      params = []        
      sql = opts.map{|k, v| params << v; "#{quoted_table_name}.#{quote_column_name k} != ?"}.join(' AND ')
      where(sql, *params)
    end
  end
end
