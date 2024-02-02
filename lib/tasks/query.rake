# frozen_string_literal: true

require "#{Rails.root}/app/services/query_constructor.rb"

namespace :Facebook do
  desc 'Query Dimension and metrics'
  task run_query: :environment do
    selected_fields = ['ads.name','ad_sets.goal','ads.type', 'ad_sets.name', 'ad_campaigns.name', 'clicks']
    filters = { 'ad_sets.name' => 'Example Ad Set', 'ad_accounts.id' => '202330961584003' }
    q = AdsQueryInterface.new
    query = q.generate_query(selected_fields, filters)

    puts "============"
    selected_fields = ['ads.name','ad_sets.goal','ads.type', 'ad_sets.name', 'ad_campaigns.name']
    query = q.generate_query(selected_fields, filters)

    # puts query
  end
end
