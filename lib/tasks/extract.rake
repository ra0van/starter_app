# frozen_string_literal: true

require "#{Rails.root}/app/services/facebook.rb"
require "#{Rails.root}/app/services/transform.rb"

namespace :Facebook do
  desc 'Fetch Data from Facebook'
  task extract: :environment do
    fb = Facebook.new

    tr = Transform.new

    tr.transform_ad_accounts(fb.get_ad_accounts('236247562146310'))

    accounts = AdAccounts.all
    accounts .map do |account|
      account_id = account[:id]
      puts account_id
      tr.transform_ad_campaigns(fb.get_ad_campaigns(account_id))
      tr.transform_ad_sets(fb.get_ad_sets(account_id))
      tr.transform_ads(fb.get_ads(account_id))

      tr.transform_adaccount_insighs(fb.get_account_insights(account_id))
      tr.transform_adcampaign_insights(fb.get_campaign_insights(account_id))
      tr.transform_adset_insights(fb.get_adset_insights(account_id))
      tr.transform_ad_insights(fb.get_ad_insights(account_id))
    end

    ActiveRecord::Base.connection.instance_variable_set :@logger, Logger.new($stdout)
    ActiveRecord::Base.logger = nil # Logger.new(STDOUT)

    # tr.transform_ad_sets(data)
  end
end
