require "#{Rails.root}/app/services/facebook.rb"
require "#{Rails.root}/app/services/transform.rb"

namespace :Facebook do

  desc "Fetch Data from Facebook"
  task extract: :environment do

    fb = Facebook.new
    #fb.get_ad_accounts("236247562146310")
    #fb.get_ad_campaigns("act_202330961584003")
    data = fb.get_ad_sets("act_202330961584003")
    
    #data = fb.get_ads("act_202330961584003")
    ActiveRecord::Base.connection.instance_variable_set :@logger, Logger.new(STDOUT)
    ActiveRecord::Base.logger = nil #Logger.new(STDOUT)
    #data = fb.get_ad_insights("act_202330961584003")

    tr = Transform.new
    tr.transform_ad_sets(data)

  end
end
