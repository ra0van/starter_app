# frozen_string_literal: true

require "#{Rails.root}/app/services/transformer.rb"

namespace :Transform do
  desc 'Transform Meta data'
  task init: :environment do
    # ActiveRecord::Base.connection.instance_variable_set :@logger, Logger.new($stdout)
    # ActiveRecord::Base.logger = Logger.new(STDOUT)
    t = Transformer.new
    t.transform('admin')
  end
end
