# frozen_string_literal: true

require "#{Rails.root}/app/services/ga_ingester.rb"

namespace :Ingest do
  desc 'Ingest GA data'
  task init: :environment do
    file_path = "#{Rails.root}/ga_revenue.csv"
    i = GA_Ingester.new(file_path)
    i.process_csv
  end
end
