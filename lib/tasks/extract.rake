# frozen_string_literal: true

require "#{Rails.root}/app/services/facebook.rb"
require "#{Rails.root}/app/services/extractor.rb"

namespace :Facebook do
  desc 'Fetch Data from Facebook'
  task extract: :environment do
    token = 'EAAKDX99BZAz4BO75vjcOZCaPL2NheZCcQYXskZB1ag6hn7hD70DtvsQf99V2tXxXg8cJDMby8ZABxvK2QhfPAi0WA9drlZBEzZCZAdraKXTOjYI7tzyWzSn1Lt0PxXdUtADzaG7mfZAidIRZAdDIPS6fGpBxyEvZC99rxLfPBQDh3sc015VOENmCHAb7M0S39gzDu0x'
    fb_user_id = '236247562146310'
    Users.create({fb_useraccount_id: fb_user_id, fb_access_token: token, username: 'admin'})

    user = Users.find_by(username: 'admin')
    fb = Facebook.new(user.fb_access_token)
    tr = Extractor.new
    tr.extract_and_save_ad_accounts(fb.get_ad_accounts(user.fb_useraccount_id), user.id)

    accounts = AdAccounts.all
    accounts.map do |account|
      account_id = account[:id]
      puts account_id
      tr.extract_and_save_ad_campaigns(fb.get_ad_campaigns('act_' + account_id))
      tr.extract_and_save_ad_sets(fb.get_ad_sets('act_' + account_id))
      tr.extract_and_save_ads(fb.get_ads('act_' + account_id))

      tr.extract_and_save_adaccount_insights(fb.get_account_insights('act_' + account_id))
      tr.extract_and_save_adcampaign_insights(fb.get_campaign_insights('act_' + account_id))
      tr.extract_and_save_adset_insights(fb.get_adset_insights('act_' + account_id))
      tr.extract_and_save_ad_insights(fb.get_ad_insights('act_' + account_id))
    end

    # ActiveRecord::Base.connection.instance_variable_set :@logger, Logger.new($stdout)
    # ActiveRecord::Base.logger = Logger.new(STDOUT)
  end
end
