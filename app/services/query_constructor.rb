class FacebookAdsQueryParser
  METRICS_COLUMNS = [
    'clicks', 'ctr', 'link_clicks', 'comments', 'impressions', 'likes', 'spend'
  ]

  HIERARCHY_MAPPING = {
    'ad_accounts' => { 'children' => ['ad_campaigns'], 'metrics_table' => 'adaccount_metrics' },
    'ad_campaigns' => { 'children' => ['ad_sets'], 'metrics_table' => 'adcampaign_metrics' },
    'ad_sets' => { 'children' => ['ads'], 'metrics_table' => 'adset_metrics' },
    'ads' => { 'metrics_table' => 'ad_metrics' }
  }.freeze

  def self.parse_and_execute(query)
    parsed_query = parse(query)
    puts parsed_query
    sql_query = build_sql_query(parsed_query)
    # result = execute_sql_query(sql_query)
    # process_result(result)
  end

  def self.parse(query)
    select_clause, where_clause = query.split('WHERE').map(&:strip)
    fields = select_clause.gsub('SELECT', '').split(',').map(&:strip)
    conditions = where_clause

    level = determine_query_level(fields +  [conditions])
    puts "Level: #{level}" 
    tables_involved, updated_fields= determine_metrics_tables(fields)

    { level: level, fields: updated_fields.join(', '), conditions: conditions, metrics_tables: tables_involved}
  end


  def self.determine_query_level(parts)
    puts "Determine Query"
    puts parts.inspect

    puts "Flatten"
    all_entities = parts.flat_map { |part| 
      puts part
      part.scan(/(\b\w+)\./).flatten 
    }.uniq
    puts "All Enti"
    puts all_entities
    highest_level = all_entities.max_by do |entity|
      puts HIERARCHY_MAPPING.keys.index(entity) || 999, entity
      HIERARCHY_MAPPING.keys.index(entity) || 999
    end
    puts "===highest=="
    puts highest_level
    HIERARCHY_MAPPING.keys.include?(highest_level) ? highest_level : 'ad_accounts'
  end


  def self.determine_metrics_tables(fields)
    puts "====Finding metrics", fields
    metrics_fields = []
    tables_involved = []

    fields.each do |field|
      entity, field_name = field.split('.')
      puts "--" + field_name

      if METRICS_COLUMNS.include?(field_name)
        # Assuming each entity has a corresponding metrics table following a naming convention
        metrics_table = "#{entity}_metrics"
        metrics_fields << "#{metrics_table}.#{field_name}"
        tables_involved << metrics_table
      else
        # For non-metrics fields, keep them as is
        metrics_fields << field
      end
    end

    [tables_involved.uniq, metrics_fields.uniq]
  end
  def self.build_sql_query(parsed_query)
    fields = parsed_query[:fields]
    conditions = parsed_query[:conditions]
    level = parsed_query[:level]
    metrics_tables = parsed_query[:metrics_tables]

    joins = metrics_tables.map do |metrics_table|
      "LEFT JOIN #{metrics_table} ON #{level}.id = #{metrics_table}.#{level.singularize}_id"
    end.join(' ')

    "SELECT #{fields} FROM #{level} #{joins} WHERE #{conditions}"
  end

  def self.execute_sql_query(sql_query)
    puts "Executing SQL query: #{sql_query}"
    [{'name' => 'Mock Campaign', 'lifetime_budget' => 1000, 'clicks' => 150}] # Mock result
  end

  def self.process_result(result)
    puts "Processed result: #{result.inspect}"
    result
  end
end

