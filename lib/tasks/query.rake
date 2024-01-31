# frozen_string_literal: true

require "#{Rails.root}/app/services/query_constructor.rb"

namespace :Facebook do
  desc 'Query Dimension and metrics'
  task run_query: :environment do
    # Test execution
    query = "SELECT ad_campaigns.name, ad_campaigns.budget, ads.clicks WHERE ad_accounts.id = 'act_202330961584003'"
    result = FacebookAdsQueryParser.parse_and_execute(query)
    puts "Query Result: #{result}"
  end
end
