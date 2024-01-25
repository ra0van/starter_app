require 'date'


class Transform
 def transform_ads(data)
  puts "Transforming"
  puts data[0].class

  ads = data.map { |record|
    {
      ad_id: record["id"],
      ad_name: record["name"],
      ad_set_id: record["adset_id"],
      ad_account_id: record["account_id"],
    }
  }

  Ads.upsert_all(ads, unique_by: :ad_id)
 end

 def transform_ad_insights(data)
   ad_insights = data.map { |insight|  
     {
       clicks: insight["clicks"],
       ctr: insight["ctr"],
       link_clicks: insight["inline_link_clicks"],
       #link_clicks_ctr: insight["link_clicks_ctr"],
       event_date: Date.strptime(insight["date_stop"], "%Y-%m-%d"),
       comments: insight["comments"],
       spend: insight["spend"],
       ad_id: insight["ad_id"],
       ad_account_id: insight["account_id"],
     }
   }
  
   AdsMetrics.upsert_all(ad_insights, unique_by: [:ad_id,:event_date])
   metrics = AdsMetrics.order('id').all
   metrics.each { |x| puts x.inspect }

 end

 def transform_ad_sets(data)
   adsets = data.map{ |set|
     {
       ad_set_id: set["id"],
       ad_set_name: set["name"],
       ad_set_goal: set["optimization_goal"],
       ad_set_daily_budget: set["daily_budget"],
       ad_set_lifetime_budget: set["lifetime_budget"],
       ad_set_billing_event: set["billing_event"],
       ad_campaign_id: set["campaign_id"],
       ad_account_id: set["account_id"],
     }
   }

  AdSets.upsert_all(adsets, unique_by: :ad_set_id)
 end


end
