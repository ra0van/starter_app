require "#{Rails.root}/app/services/facebook.rb"
require "#{Rails.root}/app/services/transform.rb"

namespace :Facebook do
  desc 'Fetch Data from Facebook'
  task extract: :environment do
    fb = Facebook.new

    tr = Transform.new

    # data = fb.get_ad_campaigns("act_202330961584003")
    data = fb.get_ad_sets('act_202330961584003')
    tr.transform_ad_sets(data)

    data = fb.get_ads('act_202330961584003')
    tr.transform_ads(data)

    data = fb.get_ad_insights('act_202330961584003')
    tr.transform_ad_insights(data)

    ActiveRecord::Base.connection.instance_variable_set :@logger, Logger.new($stdout)
    ActiveRecord::Base.logger = nil #Logger.new(STDOUT)

    # tr.transform_ad_sets(data)
  end
end
