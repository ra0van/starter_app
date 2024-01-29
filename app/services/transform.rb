require 'date'

class Transform
  def transform_ads(data)
    puts 'Transforming'
    ads = data.map { |record|
      {
        id: record['id'],
        name: record['name'],
        adset_id: record['adset_id'],
        account_id: record['account_id'],
      }
    }
    puts 'Saving Records'
    Ads.upsert_all(ads, unique_by: :id)
  end

  def transform_ad_insights(data)
    ad_insights = data.map { |insight|
      {
        clicks: insight['clicks'],
        ctr: insight['ctr'],
        link_clicks: insight['inline_link_clicks'],
        #link_clicks_ctr: insight['link_clicks_ctr'],
        event_date: Date.strptime(insight['date_stop'], '%Y-%m-%d'),
        comments: insight['comments'],
        spend: insight['spend'],
        ad_id: insight['ad_id'],
        account_id: insight['account_id']
      }
    }

    AdsMetrics.upsert_all(ad_insights, unique_by: %i[ad_id event_date])
    # metrics = AdsMetrics.order('id').all
    # metrics.each { |x| puts x.inspect }
  end

  def transform_ad_sets(data)
    adsets = data.map{ |set|
      {
        id: set['id'],
        name: set['name'],
        goal: set['optimization_goal'],
        daily_budget: set['daily_budget'],
        lifetime_budget: set['lifetime_budget'],
        billing_event: set['billing_event'],
        campaign_id: set['campaign_id'],
        account_id: set['account_id']
      }
    }

    AdSets.upsert_all(adsets, unique_by: :id)
  end

  def transform_ad_accounts(data)
    ad_accounts = data.map{ |account| 
      {
        id: account['id'],
        name: account['name'],
        currency: account['currency'],

      }
    }
  end
end
