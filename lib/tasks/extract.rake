# frozen_string_literal: true

require "#{Rails.root}/app/services/facebook.rb"
require "#{Rails.root}/app/services/transform.rb"

namespace :Facebook do
  desc 'Fetch Data from Facebook'
  task extract: :environment do
    # token = 'EAAKDX99BZAz4BO75vjcOZCaPL2NheZCcQYXskZB1ag6hn7hD70DtvsQf99V2tXxXg8cJDMby8ZABxvK2QhfPAi0WA9drlZBEzZCZAdraKXTOjYI7tzyWzSn1Lt0PxXdUtADzaG7mfZAidIRZAdDIPS6fGpBxyEvZC99rxLfPBQDh3sc015VOENmCHAb7M0S39gzDu0x'
    # fb_user_id = '236247562146310'
    # Users.create({fb_useraccount_id: fb_user_id, fb_access_token: token, username: 'admin'})

    user = Users.find_by(username: 'admin')
    fb = Facebook.new(user.fb_access_token)
    tr = Transform.new
    tr.transform_ad_accounts(fb.get_ad_accounts(user.fb_useraccount_id))

    accounts = AdAccounts.all
    accounts.map do |account|
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

    # ActiveRecord::Base.connection.instance_variable_set :@logger, Logger.new($stdout)
    # ActiveRecord::Base.logger = Logger.new(STDOUT)
  end
end
