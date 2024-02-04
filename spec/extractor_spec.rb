# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Extractor, type: :service do
  describe '#extract_and_save_ads' do
    it 'transforms and inserts ad data correctly' do
      # Mock Facebook API data
      api_data = [{ 'id' => '1', 'name' => 'Ad 1', 'adset_id' => '1', 'account_id' => 'A1' }]

      # Execute the transformation
      transform = Extractor.new
      transform.extract_and_save_ads(api_data)

      # Verify that the data is correctly transformed and upserted in the database
      expect(Ads.find_by(id: '1')).to_not be_nil
    end

    context 'when the same ad is to be updated, ad data is upserted correctly' do
      it 'transforms and upserts ad data correctly' do
        # Mock Facebook API data
        Ads.create({'id' => 1, 'name' => 'Ad 1', 'adset_id' => 'adset-1', 'account_id' => 'A1'})
        ad = Ads.find_by(id: '1')
        expect(ad.name).to eq('Ad 1')

        api_data = [{ 'id' => '1', 'name' => 'Ad 2', 'adset_id' => '1', 'account_id' => 'A1' }]
        # Execute the transformation
        transform = Extractor.new
        transform.extract_and_save_ads(api_data)

        # Verify that the data is correctly transformed and upserted in the database
        expect(Ads.find_by(id: '1')).to_not be_nil
        ad = Ads.find_by(id: '1')
        expect(ad.name).to eq('Ad 2')
      end
    end

    context 'when the input data is missing required fields' do
      it 'raises an error' do
        data = [{ 'name' => 'Ad 1' }]

        # Execute the transformation
        transform = Extractor.new
        expect { transform.extract_and_save_ads(data) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#extract_and_save_ad_insights' do
    it 'transforms and upserts ad insights data correctly' do
      # Mock Facebook API data
      api_data = [{ 'clicks' => 100, 'ctr' => 0.1, 'inline_link_clicks' => 50, 'date_stop' => '2022-01-01',
                    'comments' => 5, 'spend' => 50.0, 'ad_id' => '1', 'account_id' => 'A1' }]

      # Execute the transformation
      transform = Extractor.new
      transform.extract_and_save_ad_insights(api_data)

      # Verify that the data is correctly transformed and upserted in the database
      expect(AdMetrics.find_by(ad_id: '1')).to_not be_nil
    end

    context 'when the input data contains invalid values' do
      it 'raises an error' do
        data = [{ 'clicks' => 'invalid', 'ctr' => 0.05 }]

        # Execute the transformation
        transform = Extractor.new
        expect { transform.extract_and_save_ad_insights(data) }.to raise_error(ArgumentError)
      end
    end

    context 'when the same ad is to be updated, ad data is upserted correctly' do
      it 'transforms and upserts ad insights data correctly' do
        # Mock Facebook API data
        AdMetrics.create({'clicks' => 100, 'ctr' => 0.1, 'link_clicks' => 50, 'event_date' => '2022-01-01','comments' => 5, 'spend' => 50.0, 'ad_id' => '1', 'account_id' => 'A1' })

        ad = AdMetrics.find_by(ad_id: '1', event_date: '2022-01-01')
        expect(ad).to_not be_nil
        expect(ad.clicks).to eq(100)

        api_data = [{ 'clicks' => 500, 'ctr' => 0.1, 'inline_link_clicks' => 50, 'date_stop' => '2022-01-01','comments' => 5, 'spend' => 50.0, 'ad_id' => '1', 'account_id' => 'A1' }]
        # Execute the transformation
        transform = Extractor.new
        transform.extract_and_save_ad_insights(api_data)

        # Verify that the data is correctly transformed and upserted in the database
        ad = AdMetrics.find_by(ad_id: '1', event_date: '2022-01-01')
        expect(ad).to_not be_nil
        expect(ad.clicks).to eq(500)
      end
    end
  end

  describe '#extract_and_save_adsets' do
    it 'transforms and inserts adset data correctly' do
      # Mock Facebook API data
      api_data = [{ 'id' => '1', 'name' => 'Adset 1', 'campaign_id' => '1', 'account_id' => 'A1' }]

      # Execute the transformation
      transform = Extractor.new
      transform.extract_and_save_ad_sets(api_data)

      # Verify that the data is correctly transformed and upserted in the database
      expect(AdSets.find_by(id: '1')).to_not be_nil
    end

    context 'when the same ad is to be updated, ad data is upserted correctly' do
      it 'transforms and upserts ad data correctly' do
        # Mock Facebook API data
        AdSets.create({'id' => 1, 'name' => 'Adset 1', 'campaign_id' => '1', 'account_id' => 'A1'})
        ad = AdSets.find_by(id: '1')
        expect(ad.name).to eq('Adset 1')

        api_data = [{ 'id' => '1', 'name' => 'Adset 2', 'campaign_id' => '1', 'account_id' => 'A1' }]
        # Execute the transformation
        transform = Extractor.new
        transform.extract_and_save_ad_sets(api_data)

        # Verify that the data is correctly transformed and upserted in the database
        expect(AdSets.find_by(id: '1')).to_not be_nil
        ad = AdSets.find_by(id: '1')
        expect(ad.name).to eq('Adset 2')
      end
    end

    context 'when the input data is missing required fields' do
      it 'raises an error' do
        data = [{ 'name' => 'Adset 1' }]

        # Execute the transformation
        transform = Extractor.new
        expect { transform.extract_and_save_ad_sets(data) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#extract_and_save_adset_metrics' do
    it 'transforms and upserts adset metrics data correctly' do
      # Mock Facebook API data
      api_data = [{ 'clicks' => 100, 'ctr' => 0.1, 'inline_link_clicks' => 50, 'date_stop' => '2022-01-01',
                    'comments' => 5, 'spend' => 50.0, 'adset_id' => '1', 'account_id' => 'A1' }]

      # Execute the transformation
      transform = Extractor.new
      transform.extract_and_save_adset_insights(api_data)

      # Verify that the data is correctly transformed and upserted in the database
      expect(AdsetMetrics.find_by(adset_id: '1')).to_not be_nil
    end

    context 'when the input data is missing required fields' do
      it 'raises an error' do
        data = [{ 'clicks' => 'invalid', 'ctr' => 0.05 }]

        # Execute the transformation
        transform = Extractor.new
        expect { transform.extract_and_save_adset_insights(data) }.to raise_error(ArgumentError)
      end
    end

    context 'when the same ad is to be updated, ad data is upserted correctly' do
      it 'transforms and upserts ad insights data correctly' do
        # Mock Facebook API data
        AdsetMetrics.create({'clicks' => 100, 'ctr' => 0.1, 'link_clicks' => 50, 'event_date' => '2022-01-01','comments' => 5, 'spend' => 50.0, 'adset_id' => '1', 'account_id' => 'A1' })

        ad = AdsetMetrics.find_by(adset_id: '1', event_date: '2022-01-01')
        expect(ad).to_not be_nil
        expect(ad.clicks).to eq(100)

        api_data = [{ 'clicks' => 500, 'ctr' => 0.1, 'inline_link_clicks' => 50, 'date_stop' => '2022-01-01','comments' => 5, 'spend' => 50.0, 'adset_id' => '1', 'account_id' => 'A1' }]
        # Execute the transformation
        transform = Extractor.new
        transform.extract_and_save_adset_insights(api_data)

        # Verify that the data is correctly transformed and upserted in the database
        ad = AdsetMetrics.find_by(adset_id: '1', event_date: '2022-01-01')
        expect(ad).to_not be_nil
        expect(ad.clicks).to eq(500)
      end
    end
  end

  describe '#transform_campaigns' do
    it 'transforms and inserts campaign data correctly' do
      # Mock Facebook API data
      api_data = [{ 'id' => '1', 'name' => 'Campaign 1', 'account_id' => 'A1', 'start_time' => '2022-01-01' }]

      # Execute the transformation
      transform = Extractor.new
      transform.extract_and_save_ad_campaigns(api_data)

      # Verify that the data is correctly transformed and upserted in the database
      expect(AdCampaigns.find_by(id: '1')).to_not be_nil
    end

    context 'when the same campaign is to be updated, ad data is upserted correctly' do
      it 'transforms and upserts campaign  data correctly' do
        # Mock Facebook API data
        AdCampaigns.create({ 'id' => 1, 'name' => 'Campaign 1', 'account_id' => 'A1', 'startdate' => '2022-01-01' })
        ad = AdCampaigns.find_by(id: '1')
        expect(ad.name).to eq('Campaign 1')

        api_data = [{ 'id' => '1', 'name' => 'Campaign 2', 'account_id' => 'A1', 'start_time' => '2022-01-01' }]
        # Execute the transformation
        transform = Extractor.new
        transform.extract_and_save_ad_campaigns(api_data)

        # Verify that the data is correctly transformed and upserted in the database
        expect(AdCampaigns.find_by(id: '1')).to_not be_nil
        ad = AdCampaigns.find_by(id: '1')
        expect(ad.name).to eq('Campaign 2')
      end
    end

    context 'when the input data is missing required fields' do
      it 'raises an error' do
        data = [{ 'name' => 'Ad 1' }]

        # Execute the transformation
        transform = Extractor.new
        expect { transform.extract_and_save_ad_campaigns(data) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#transform_campaign_metrics' do
    it 'transforms and inserts campaign metrics data correctly' do
      # Mock Facebook API data
      api_data = [{ 'clicks' => 100, 'ctr' => 0.1, 'inline_link_clicks' => 50, 'date_stop' => '2022-01-01',
                    'comments' => 5, 'spend' => 50.0, 'campaign_id' => '1', 'account_id' => 'A1' }]

      # Execute the transformation
      transform = Extractor.new
      transform.extract_and_save_adcampaign_insights(api_data)

      # Verify that the data is correctly transformed and upserted in the database
      expect(AdcampaignMetrics.find_by(campaign_id: '1')).to_not be_nil
    end

    context 'when the input data is missing required fields' do
      it 'raises an error' do
        data = [{ 'clicks' => 'invalid', 'ctr' => 0.05 }]

        # Execute the transformation
        transform = Extractor.new
        expect { transform.extract_and_save_adcampaign_insights(data) }.to raise_error(ArgumentError)
      end
    end

    context 'when the same campaign is to be updated, ad data is upserted correctly' do
      it 'transforms and upserts ad insights data correctly' do
        # Mock Facebook API data
        AdcampaignMetrics.create({'clicks' => 100, 'ctr' => 0.1, 'link_clicks' => 50, 'event_date' => '2022-01-01','comments' => 5, 'spend' => 50.0, 'campaign_id' => '1', 'account_id' => 'A1' })

        ad = AdcampaignMetrics.find_by(campaign_id: '1', event_date: '2022-01-01')
        expect(ad).to_not be_nil
        expect(ad.clicks).to eq(100)

        api_data = [{ 'clicks' => 500, 'ctr' => 0.1, 'inline_link_clicks' => 50, 'date_stop' => '2022-01-01','comments' => 5, 'spend' => 50.0, 'campaign_id' => '1', 'account_id' => 'A1' }]
        # Execute the transformation
        transform = Extractor.new
        transform.extract_and_save_adcampaign_insights(api_data)

        # Verify that the data is correctly transformed and upserted in the database
        ad = AdcampaignMetrics.find_by(campaign_id: '1', event_date: '2022-01-01')
        expect(ad).to_not be_nil
        expect(ad.clicks).to eq(500)
      end
    end
  end

  describe '#extract_and_save_ad_accounts' do
    it 'transforms and inserts ad account data correctly' do
      # Mock Facebook API data
      api_data = [{ 'id' => 'A1', 'name' => 'Account 1', 'currency' => 'USD' }]

      # Execute the transformation
      transform = Extractor.new
      transform.extract_and_save_ad_accounts(api_data)

      # Verify that the data is correctly transformed and upserted in the database
      expect(AdAccounts.find_by(id: 'A1')).to_not be_nil
    end

    context 'when the same ad account is to be updated, ad account data is upserted correctly' do
      it 'transforms and upserts ad account data correctly' do
        # Mock Facebook API data
        AdAccounts.create({ 'id' => 'A1', 'name' => 'Account 1', 'currency' => 'USD' })
        account = AdAccounts.find_by(id: 'A1')
        expect(account.name).to eq('Account 1')

        api_data = [{ 'id' => 'A1', 'name' => 'Account 2', 'currency' => 'EUR' }]
        # Execute the transformation
        transform = Extractor.new
        transform.extract_and_save_ad_accounts(api_data)

        # Verify that the data is correctly transformed and upserted in the database
        account = AdAccounts.find_by(id: 'A1')
        expect(account.name).to eq('Account 2')
        expect(account.currency).to eq('EUR')
      end
    end

    context 'when the input data is missing required fields' do
      it 'raises an error' do
        data = [{ 'name' => 'Account 1' }]

        # Execute the transformation
        transform = Extractor.new
        expect { transform.extract_and_save_ad_accounts(data) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#extract_and_save_adaccount_insights' do
    it 'transforms and inserts ad account insights data correctly' do
      # Mock Facebook API data
      api_data = [{ 'clicks' => 100, 'ctr' => 0.1, 'inline_link_clicks' => 50, 'date_stop' => '2022-01-01',
                    'comments' => 5, 'spend' => 50.0, 'account_id' => 'A1' }]

      # Execute the transformation
      transform = Extractor.new
      transform.extract_and_save_adaccount_insights(api_data)

      # Verify that the data is correctly transformed and upserted in the database
      expect(AdaccountMetrics.find_by(account_id: 'A1')).to_not be_nil
    end

    context 'when the input data is missing required fields' do
      it 'raises an error' do
        data = [{ 'clicks' => 'invalid', 'ctr' => 0.05 }]

        # Execute the transformation
        transform = Extractor.new
        expect { transform.extract_and_save_adaccount_insights(data) }.to raise_error(ArgumentError)
      end
    end

    context 'when the same ad account insights data is to be updated, insights data is upserted correctly' do
      it 'transforms and upserts ad account insights data correctly' do
        # Mock Facebook API data
        AdaccountMetrics.create({'clicks' => 100, 'ctr' => 0.1, 'link_clicks' => 50, 'event_date' => '2022-01-01', 'comments' => 5, 'spend' => 50.0, 'account_id' => 'A1' })

        insight = AdaccountMetrics.find_by(account_id: 'A1', event_date: '2022-01-01')
        expect(insight).to_not be_nil
        expect(insight.clicks).to eq(100)

        api_data = [{ 'clicks' => 500, 'ctr' => 0.1, 'inline_link_clicks' => 50, 'date_stop' => '2022-01-01', 'comments' => 5, 'spend' => 50.0, 'account_id' => 'A1' }]
        # Execute the transformation
        transform = Extractor.new
        transform.extract_and_save_adaccount_insights(api_data)

        # Verify that the data is correctly transformed and upserted in the database
        insight = AdaccountMetrics.find_by(account_id: 'A1', event_date: '2022-01-01')
        expect(insight).to_not be_nil
        expect(insight.clicks).to eq(500)
      end
    end
  end
end
