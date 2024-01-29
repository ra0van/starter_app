# frozen_string_literal: true

require "#{Rails.root}/app/services/facebook.rb"
require "#{Rails.root}/app/services/transform.rb"

namespace :Facebook do
  desc 'Fetch Data from Facebook'
  task extract: :environment do
    fb = Facebook.new

    tr = Transform.new

    tr.transform_ad_accounts(fb.get_ad_accounts('236247562146310'))
    tr.transform_ad_campaigns(fb.get_ad_campaigns('act_202330961584003'))
    tr.transform_ad_sets(fb.get_ad_sets('act_202330961584003'))
    tr.transform_ads(fb.get_ads('act_202330961584003'))

    tr.transform_adaccount_insighs(fb.get_account_insights('act_202330961584003'))
    tr.transform_adcampaign_insights(fb.get_campaign_insights('act_202330961584003'))
    tr.transform_adset_insights(fb.get_adset_insights('act_202330961584003'))
    tr.transform_ad_insights(fb.get_ad_insights('act_202330961584003'))

    ActiveRecord::Base.connection.instance_variable_set :@logger, Logger.new($stdout)
    ActiveRecord::Base.logger = nil # Logger.new(STDOUT)

    # tr.transform_ad_sets(data)
  end
end
