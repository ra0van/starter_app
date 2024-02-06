# frozen_string_literal: true

class AdsQueryInterface
  METRICS_COLUMNS = %w[
    clicks ctr link_clicks comments impressions likes spend links_ctr cplc
  ].freeze

  DERIEVED_METRICS = %w[
    ctr link_ctr cplc
  ].freeze
  HIERARCHY = { 'account' => 0, 'campaign' => 1, 'adset' => 2, 'ad' => 3 }.freeze

  JOIN_KEY = {
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
    puts level
    puts "dimensions___ #{dimensions.inspect}"
    puts "metrics ___ #{metrics.inspect}"
    query = construct_sql_query(metrics, dimensions, filters, level)
    # Add Date filter
    # Add Account filter
  end

  def separate_fields(fields)
    metrics, dimensions = fields.partition { |field| METRICS_COLUMNS.include?(field) }
    lowest_dim_index = dimensions.map { |field| HIERARCHY[field.split('.').first] }.max || -1
    [metrics, dimensions, HIERARCHY.key(lowest_dim_index)]
  end

  def transform_metrics(fields, level)
    prefix = METRICS_ASSOCIATION[level]
    fields.map do |field|
      if DERIEVED_METRICS.include?(field)
        case field
        when 'ctr'
          "SUM (#{prefix}.CLICKS) as clicks, SUM(#{prefix}.IMPRESSIONS) AS impressions"
        when 'links_ctr'
          "SUM (#{prefix}.LINK_CLICKS) as link_clicks, SUM(#{prefix}.LINK_CLICK_IMPRESSION)  AS link_click_impression"
        when 'cplc'
          "SUM (#{prefix}.LINK_CLICK_COST) as link_click_cost, SUM(#{prefix}.LINK_CLICKS)  AS link_clicks"
        end
      else
        "SUM (#{prefix}.#{field}) as #{field}"
      end
    end
  end

  def transform_dimensions(fields, level)
    fields.map do |field|
      flevel, column = field.split('.')
      if flevel != level
        field.sub('.', '_')
      else
        column
      end
    end
  end

  def construct_sql_query(metrics, dimensions,filters, level)
    dimensions = transform_dimensions(dimensions, level)
    metrics = transform_metrics(metrics, level)
    puts "dimensions___ #{dimensions.inspect}"
    puts "metrics ___ #{metrics.inspect}"

    metrics_level = METRICS_ASSOCIATION[level]
    select_query = 'SELECT ' + (metrics + dimensions).join(',')
    from_query = 'FROM ' + metrics_level
    join_query = " JOIN  #{level}_dimensions ON  #{metrics_level}.#{JOIN_KEY[metrics_level]} = #{level}_dimensions.id"
    group_by_query = ' GROUP BY ' + dimensions.join(',')
    filter_query = construct_filter_query(filters, level)

    [select_query, from_query, join_query, filter_query, group_by_query].join(' ')
  end

  def construct_filter_query(filters, level)
    query = []
    filters.each do |key,value|
      t_key = transform_dimensions([key], level)
      query.push("#{t_key} = #{value}")
    end
    'WHERE ' + query.join(',')
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
