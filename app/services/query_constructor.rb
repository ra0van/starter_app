# frozen_string_literal: true

class AdsQueryInterface
  METRICS_COLUMNS = %w[
    clicks ctr link_clicks comments impressions likes spend links_ctr cplc
  ].freeze

  DERIVED_METRICS = %w[
    ctr link_ctr cplc
  ].freeze

  HIERARCHY = { 'account' => 0, 'campaign' => 1, 'adset' => 2, 'ad' => 3 }.freeze

  JOIN_KEY = {
    'adaccount_metrics' => 'account_id', 'campaign_metrics' => 'campaign_id',
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
    execute_and_print_results(query)
  end

  private

  def separate_fields(fields)
    metrics, dimensions = fields.partition { |field| METRICS_COLUMNS.include?(field) }
    lowest_dim_index = dimensions.map { |field| HIERARCHY[field.split('.').first] }.max || -1
    [metrics, dimensions, HIERARCHY.key(lowest_dim_index)]
  end

  def transform_metrics(metrics, level)
    prefix = METRICS_ASSOCIATION[level]
    metrics.map do |metric|
      case metric
      when 'ctr', 'links_ctr', 'cplc'
        transform_derived_metrics(metric, prefix)
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
    select_query = "SELECT #{(metrics + dimensions).join(', ')}"
    from_query = "FROM #{METRICS_ASSOCIATION[level]}"
    join_query = "JOIN #{level}_dimensions ON #{METRICS_ASSOCIATION[level]}.#{JOIN_KEY[METRICS_ASSOCIATION[level]]} = #{level}_dimensions.id"
    where_query = construct_where_query(filters, level)
    group_by_query = "GROUP BY #{dimensions.join(', ')}"

    [select_query, from_query, join_query, where_query, group_by_query].compact.join(' ') + ";"
  end

  def construct_where_query(filters, level)
    return nil if filters.empty?

    conditions = filters.map do |key, value|
      transformed_key = transform_dimensions([key], level).first

      if value.is_a?(Array)
        # Join the array values into a string, properly escaped for SQL.
        value_list = value.map { |v| ActiveRecord::Base.connection.quote(v) }.join(', ')
        "#{transformed_key} IN (#{value_list})"
      else
        "#{transformed_key} = #{ActiveRecord::Base.connection.quote(value)}"
      end
    end.join(' AND ')

    "WHERE #{conditions}"
  end

  def execute_and_print_results(query)
    results = ActiveRecord::Base.connection.execute(query)
    results.each do |row|
      row.each { |column, value| puts "#{column}: #{value}" }
    end
  end
end

