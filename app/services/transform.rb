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
end
