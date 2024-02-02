# frozen_string_literal: true

class AdsQueryInterface
  METRICS_COLUMNS = %w[
    clicks ctr link_clicks comments impressions likes spend
  ].freeze

  HIERARCHY = { 'ad_accounts' => 0, 'ad_campaigns' => 1, 'ad_sets' => 2, 'ads' => 3
  }.freeze

  JOIN_KEY = { 'ad_accounts' => 'id', 'ad_campaigns' => 'account_id', 'ad_sets' => 'campaign_id', 'ads' => 'adset_id', 'adaccount_metrics' => 'account_id', 'campaign_metrics' => 'campaign_id', 'adset_metrics' => 'adset_id', 'ad_metrics' => 'ad_id'
  }.freeze

  # Maps entities to their corresponding metrics tables
  METRICS_ASSOCIATION = {
    'ads' => 'ad_metrics',
    'ad_sets' => 'adset_metrics',
    'ad_campaigns' => 'adcampaign_metrics',
    'ad_accounts' => 'adaccount_metrics'
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
    metrics = []
    dimensions = []
    lowest_dim_index = -1
    fields.each do |field|
      if METRICS_COLUMNS.include? field
        metrics.push(field)
      else
        dimensions.push(field)
        node, = field.split('.')
        puts node.inspect
        lowest_dim_index = [HIERARCHY[node], lowest_dim_index].max
      end
    end
    [metrics, dimensions, HIERARCHY.key(lowest_dim_index)]
  end

  def prefix_metrics(fields, level)
    prefix = METRICS_ASSOCIATION[level]
    fields.map { |field| "#{prefix}.#{field}" }
  end

  def construct_sql_query(metrics, dimensions, level)
    nodes = dimensions.map do |item|
      entity, = item.split('.')
      entity
    end
    # Step 2: Sort by hierarchy value in descending order and remove duplicates
    nodes = nodes.uniq.sort_by { |item| - HIERARCHY[item] }

    table = metrics.empty? ? nodes.shift : METRICS_ASSOCIATION[level]

    # TODO : If Join is not incremental, then fill the blanks before joining
    join_query = ["FROM #{table}"]
    prev = table
    nodes.each do |node|
      join_query.push("INNER JOIN #{node} on #{prev}.#{JOIN_KEY[prev]} = #{node}.id")
      prev = node
    end

    select_query = ['SELECT']
    metrics.each do |metric|
      select_query.push("#{metric},")
    end
    dimensions.each do |dimension|
      select_query.push("#{dimension},")
    end

    select_query.join(' ').chop + ' ' + join_query.join(' ')
  end
end
