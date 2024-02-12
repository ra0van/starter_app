# frozen_string_literal: true

class AdsQueryInterface
  METRICS_COLUMNS = %w[
    clicks ctr link_clicks comments impressions likes spend links_ctr cplc roi spend revenue
  ].freeze

  DERIVED_METRICS = %w[
    ctr link_ctr cplc roi
  ].freeze

  HIERARCHY = { 'account' => 0, 'campaign' => 1, 'adset' => 2, 'ad' => 3 }.freeze

  JOIN_KEY = {
    'adaccount_metrics' => 'account_id', 'adcampaign_metrics' => 'campaign_id',
    'adset_metrics' => 'adset_id', 'ad_metrics' => 'ad_id'
  }.freeze

  METRICS_ASSOCIATION = {
    'ad' => 'ad_metrics',
    'adset' => 'adset_metrics',
    'campaign' => 'adcampaign_metrics',
    'account' => 'adaccount_metrics'
  }.freeze

  def generate_query(fields, filters)
    metrics, dimensions, level = separate_fields(fields)
    transformed_metrics = transform_metrics(metrics, level)
    transformed_dimensions = transform_dimensions(dimensions, level)

    query = construct_sql_query(transformed_metrics, transformed_dimensions, filters, level)
    execute_and_print_results(query, fields, level)
  end

  private

  def separate_fields(fields)
    metrics, dimensions = fields.partition { |field| METRICS_COLUMNS.include?(field) }
    puts dimensions
    lowest_dim_index = dimensions.map { |field| HIERARCHY[field.split('.').first] }.max || -1
    [metrics, dimensions, HIERARCHY.key(lowest_dim_index)]
  end

  def transform_metrics(metrics, level)
    prefix = METRICS_ASSOCIATION[level]
    metrics.map do |metric|
      case metric
      when 'ctr', 'links_ctr', 'cplc', 'roi' 
        transform_derived_metrics(metric, prefix)
      when 'revenue'
        'SUM(google_revenues.revenue) AS revenue'
      else
        "SUM(#{prefix}.#{metric}) AS #{metric}"
      end
    end
  end

  def transform_derived_metrics(metric, prefix)
    case metric
    when 'ctr'
      "SUM(#{prefix}.clicks) AS clicks, SUM(#{prefix}.impressions) AS impressions"
    when 'links_ctr'
      "SUM(#{prefix}.link_clicks) AS link_clicks, SUM(#{prefix}.link_click_impression) AS link_click_impression"
    when 'cplc'
      "SUM(#{prefix}.link_click_cost) AS link_click_cost, SUM(#{prefix}.link_clicks) AS link_clicks"
    when 'roi'
      "SUM(#{prefix}.spend) AS spend, SUM(google_revenues.revenue) AS revenue"
    end
  end

  def transform_dimensions(dimensions, level)
    prefix = "#{level}_dimensions."
    dimensions.map do |dimension|
      flevel, column = dimension.split('.')
      flevel != level ? "#{prefix}#{dimension.sub('.', '_')}" : "#{prefix}#{column}"
    end
  end

  def construct_sql_query(metrics, dimensions, filters, level)
    # Determine the primary dimension and metrics table names
    primary_dimension_table = "#{level}_dimensions"
    metrics_table = METRICS_ASSOCIATION[level]

    # Start constructing the SQL query
    select_query = "SELECT #{(dimensions + metrics).join(', ')}"
    from_query = "FROM #{metrics_table}"

    # Adjust the join to link the primary dimension table with the metrics table
    join_query = "LEFT JOIN #{primary_dimension_table} ON #{primary_dimension_table}.id =  #{metrics_table}.#{JOIN_KEY[metrics_table]}"
    revenues_join = "LEFT JOIN google_revenues ON google_revenues.#{JOIN_KEY[metrics_table]} = #{metrics_table}.#{JOIN_KEY[metrics_table]} AND #{metrics_table}.event_date = google_revenues.event_date"

    where_query = construct_where_query(filters, level)
    group_by_query = "GROUP BY #{dimensions.join(', ')}"

    [select_query, from_query, join_query, revenues_join, where_query, group_by_query].compact.join(' ') + ";"
  end

  def construct_where_query(filters, level)
    return nil if filters.empty?

    conditions = filters.map do |key, value|
      # transformed_key = transform_dimensions([key], level).first
      transformed_key = if key.to_s.downcase.include?('date')
                          # Date filters should be applied to the metrics table
                          "#{METRICS_ASSOCIATION[level]}.#{key}"
                        else
                          # Other filters are applied based on dimensions
                          transform_dimensions([key], level).first
                        end
      if key.to_s.downcase.include?('date')
        if value.is_a?(String)
          date = ActiveRecord::Base.connection.quote(value)
          "#{transformed_key} = #{date}"
        elsif value.is_a?(Array) && value.length == 2
          start_date = ActiveRecord::Base.connection.quote(value.first)
          end_date = ActiveRecord::Base.connection.quote(value.last)
          "#{transformed_key} BETWEEN #{start_date} AND #{end_date}"
        end
      elsif value.is_a?(Array)
        # Join the array values into a string, properly escaped for SQL.
        value_list = value.map { |v| ActiveRecord::Base.connection.quote(v) }.join(', ')
        "#{transformed_key} IN (#{value_list})"
      else
        "#{transformed_key} = #{ActiveRecord::Base.connection.quote(value)}"
      end
    end.join(' AND ')

    "WHERE #{conditions}"
  end

  def execute_and_print_results(query, fields, level)
    puts query
    results = ActiveRecord::Base.connection.execute(query)

    final_columns_set = [].to_set

    enriched_results = results.map do |row|
      convert_derived_metrics(row, fields)
      final_columns_set.merge(row.keys)
      row
    end

    final_columns_set = final_columns_set.select do |col|
      if METRICS_COLUMNS.include?(col)
        fields.include?(col)
      else
        true
      end
    end

    puts "Columns: #{final_columns_set.join(', ')}"

    puts "#{results.count} records fetched"
    enriched_results.each do |row|
      final_columns_set.each do |field|
        value = row.has_key?(field) ? (row[field].nil? ? 'NULL' : row[field]) : 'N/A'
        puts "#{field}: #{value}"
      end
      puts row
      puts '====='
    end
  end

  def convert_derived_metrics(row, metrics)
    # Calculate and add derived metrics directly to the row
    if metrics.include?('ctr') && row.has_key?('clicks') && row.has_key?('impressions')
      clicks = row['clicks'].to_f
      impressions = row['impressions'].to_f
      # Only add 'ctr' if both clicks and impressions are present and not nil
      row['ctr'] = impressions > 0 ? ((clicks / impressions).round(4))* 100 : nil unless clicks.nil? || impressions.nil?
    end

    if metrics.include?('links_ctr') && row.has_key?('link_clicks') && row.has_key?('link_click_impressions')
      link_clicks = row['link_clicks'].to_f
      link_click_impressions = row['link_click_impressions'].to_f
      # Only add 'links_ctr' if both link_clicks and link_click_impressions are present and not nil
      row['links_ctr'] = link_click_impressions > 0 ? ((link_clicks / link_click_impressions).round(4)) * 100 : nil unless link_clicks.nil? || link_click_impressions.nil?
    end

    if metrics.include?('cplc') && row.has_key?('link_click_cost') && row.has_key?('link_clicks')
      link_click_cost = row['link_click_cost'].to_f
      link_clicks = row['link_clicks'].to_f
      # Only add 'cplc' if both link_click_cost and link_clicks are present and not nil
      row['cplc'] = link_clicks > 0 ? (link_click_cost / link_clicks).round(4) : nil unless link_click_cost.nil? || link_clicks.nil?
    end

    if metrics.include?('roi') && row.has_key?('spend') && row.has_key?('revenue')
      spend = row['spend'].to_f
      revenue = row['revenue'].to_f
      if row['spend'] != nil || row['revenue'] != nil
        row['roi'] = spend != 0 && !spend.nil? && revenue != 0 && !revenue.nil? ? (revenue / spend).round(4) : nil
      end
    end
  end
end
