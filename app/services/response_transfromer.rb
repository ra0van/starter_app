# frozen_string_literal : true

class ResponseTransformer
  def transform(dimensions, fields, query)
    results = ActiveRecord::Base.connection.execute(sql)
    puts results
  end
end
