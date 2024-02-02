# frozen_string_literal: true

class AdsQueryInterface
  METRICS_COLUMNS = %w[
    clicks ctr link_clicks comments impressions likes spend
  ].freeze

  HIERARCHY = { 'ad_accounts' => 0, 'ad_campaigns' => 1, 'ad_sets' => 2, 'ads' => 3
  }.freeze

  # Maps entities to their corresponding metrics tables
  METRICS_ASSOCIATION = {
    'ads' => 'ad_metrics',
    'ad_sets' => 'adset_metrics',
    'ad_campaigns' => 'adcampaign_metrics',
    'ad_accounts' => 'adaccount_metrics'
  }.freeze

  def generate_query(fields, filters)
    metrics, dimensions, levelarate_fields(fields)
    metrics = prefix_metrics(metrics, level)
    join(metrics, dimensions, level)
    # Join LD & LM
    # Join Other Dimensions
    # Add Date filter
    # Add Account filter
  end

  def separate_fields(fields)
    metrics = [], dimensions = []
    lowest_dim_index = 999
    fields.each do |field|
      if METRICS_COLUMNS.include? field
        metrics << field
      else
        dimensions << field
        node, = field.split('.')
        lowest_dim_index = HIERARCHY[node] > lowest_dim_index ? HIERARCHY[node] : lowest_dim_index
      end
    end

    [metrics, dimensions, HIERARCHY.key(lowest_dim_index)]
  end

  def prefix_metrics(fields, level)
    prefix = METRICS_ASSOCIATION[level]
    fields.map { |field| "#{prefix}.#{field}" }
  end

  def join(metrics, dimensions, level)
    nodes = dimensions.map do |item|
      entity, = item.split('.')
      entity
    end
    # Step 2: Sort by hierarchy value in descending order and remove duplicates
    nodes = nodes.uniq.sort_by { |item| - HIERARCHY[item] }
    
    if !metrics.empty?
      

  end

  def get_lowest_node(tables, hierarchy)
    level = tables.max_by do |table|
      hierarchy[table] || 999
    end
    puts level
  end
end

