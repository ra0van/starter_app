# frozen_string_literal: true

class AdsQueryInterface
  METRICS_COLUMNS = %w[
    clicks ctr link_clicks comments impressions likes spend
  ].freeze

  HIERARCHY = { 'account' => 0, 'campaign' => 1, 'adset' => 2, 'ad' => 3 }.freeze

  JOIN_KEY = {
    'ad_accounts' => 'id', 'ad_campaigns' => 'account_id', 'ad_sets' => 'campaign_id', 'ads' => 'adset_id',
    'adaccount_metrics' => 'account_id', 'campaign_metrics' => 'campaign_id',
    'adset_metrics' => 'adset_id', 'ad_metrics' => 'ad_id'
  }.freeze

  # Maps entities to their corresponding metrics tables
  METRICS_ASSOCIATION = {
    'ad' => 'ad_metrics',
    'adset' => 'adset_metrics',
    'campaign' => 'adcampaign_metrics',
    'account' => 'adaccount_metrics'
  }.freeze

  def generate_query(fields, filters)
    metrics, dimensions, level = separate_fields(fields)
    metrics = prefix_metrics(metrics, level)
    query = construct_sql_query(metrics, dimensions, level)
    puts query
    # Add Date filter
    # Add Account filter
  end

  def separate_fields(fields)
    metrics, dimensions = fields.partition { |field| METRICS_COLUMNS.include?(field) }
    lowest_dim_index = dimensions.map { |field| HIERARCHY[field.split('.').first] }.max || -1
    [metrics, dimensions, HIERARCHY.key(lowest_dim_index)]
  end

  def prefix_metrics(fields, level)
    prefix = METRICS_ASSOCIATION[level]
    fields.map { |field| "#{prefix}.#{field}" }
  end

  def construct_sql_query(metrics, dimensions, level)
    dimension_entities = dimensions.map { |dim| dim.split('.').first }.uniq
    sorted_nodes = dimension_entities.sort_by { |entity| -HIERARCHY[entity] }

    table = metrics.empty? ? sorted_nodes.shift : METRICS_ASSOCIATION[level]
    join_query = construct_join_query(sorted_nodes, table)
    select_query = construct_select_query(metrics, dimensions)

    "#{select_query} FROM #{table} #{join_query}"
  end

  def construct_join_query(nodes, table)
    join_query = []
    prev = table
    nodes.each do |node|
      prev_key = JOIN_KEY[node] || 'id'
      join_query.push("INNER JOIN #{node} ON #{prev}.#{prev_key} = #{node}.id")
      prev = node
    end
    join_query.join(' ')
  end

  def construct_select_query(metrics, dimensions)
    'SELECT ' + (metrics + dimensions).join(', ')
  end
end
