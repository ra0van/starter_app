# frozen_string_literal: true

require "#{Rails.root}/app/services/query_constructor.rb"

namespace :Facebook do
  desc 'Query Dimension and metrics'
  task run_query: :environment do
    # selected_fields = ['ad.name','adset.goal','ad.type', 'adset.name', 'campaign.name', 'clicks', 'account.currency', 'ctr', 'cplc']
    filters = { 'account.id' => ['273283240061513'] }
    q = AdsQueryInterface.new
    # query = q.generate_query(selected_fields, filters)
    # puts query

    puts "============"
    #selected_fields = ['adset.name', 'campaign.name', 'account.name', 'account.currency', 'clicks', 'ctr', 'cplc', 'spend', 'roi', 'revenue']
    selected_fields = ['account.name', 'spend', 'clicks', 'revenue', 'roi']
    query = q.generate_query(selected_fields,  { 'event_date' => ['27/01/2024','03/02/2024'] })
    # puts query
  end
end
