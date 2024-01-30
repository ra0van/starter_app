# frozen_string_literal: true

class QueryConstructorService
  HIERARCHY = ['account', 'campaign', 'adset', 'ad']

  def initialize(query_params)
    @date_range = query_params[:daterange]
    @dimensions_metrics = query_params[:'dimensions&Metrics'].split(', ').map(&:strip)
  end

  def execute
    validate_inputs
    results = construct_query
    format_results(results)
  end

  private

  def validate_inputs
    # Implement validations for date_range, dimensions, and metrics
    # Example: Check if @date_range is a valid date range
  end

  def construct_query
    dimension_tables, metrics = @dimensions_metrics.partition { |dm| dm.include?('.') }
    lowest_node = identify_lowest_node(dimension_tables)

    query = model_for(lowest_node).all
    query = apply_joins(query, dimension_tables, lowest_node)
    query = query.where(event_date: @date_range[:start]..@date_range[:end])
    query.select(metrics.join(", "))
  end

  def identify_lowest_node(dimension_tables)
    dimension_tables.map { |dt| dt.split('.').first }.max_by { |d| HIERARCHY.index(d) }
  end

  def model_for(node)
    # Return the model class based on the node name
    case node
    when 'account'
      Account
    when 'campaign'
      Campaign
    when 'adset'
      AdSet
    when 'ad'
      Ad
    else
      raise ArgumentError, "Invalid node: #{node}"
    end
  end

  def apply_joins(query, dimension_tables, lowest_node)
    # Apply necessary joins based on the dimension tables and the lowest node
    # Be mindful of avoiding unnecessary joins
    dimension_tables.each do |dimension_table|
      node, parent = dimension_table.split('.').first(2)
      case node
      when 'campaign'
        query = query.joins("INNER JOIN ad_sets ON ad_sets.campaign_id = #{node}s.id") if parent != 'account'
      when 'adset'
        query = query.joins("INNER JOIN ads ON ads.ad_set_id = #{node}s.id") if parent != 'campaign'
      when 'ad'
        query = query.joins("INNER JOIN ad_sets ON ad_sets.id = ads.ad_set_id") if parent != 'adset'
      end
    end
    query
  end

  def format_results(results)
    results.as_json
  end
end
