# frozen_string_literal: true

require "#{Rails.root}/app/services/query_constructor.rb"

namespace :Facebook do
  desc 'Query Dimension and metrics'
  task run_query: :environment do
    selected_fields = ['ad.name','adset.goal','ad.type', 'adset.name', 'campaign.name', 'clicks', 'account.currency', 'ctr', 'cplc']
    filters = { 'adset.name' => 'Example Ad Set', 'account.id' => '202330961584003' }
    q = AdsQueryInterface.new
    query = q.generate_query(selected_fields, filters)
    puts query

    puts "============"
    selected_fields = ['ad.name','adset.goal','ad.type', 'adset.name', 'campaign.name', 'account.currency']
    query = q.generate_query(selected_fields, filters)
    puts query
  end
end
