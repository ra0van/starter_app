# frozen_string_literal : true

class ResponseTransformer
  def transform(dimensions, metrics, query)
    results = ActiveRecord::Base.connection.execute(sql)
    puts results
  end
end
