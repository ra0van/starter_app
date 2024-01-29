# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transform, type: :service do
  describe '#transform_ads' do
    it 'transforms and upserts ad data correctly' do
      # Mock Facebook API data
      api_data = [{ 'id' => '1', 'name' => 'Ad 1', 'adset_id' => '1', 'account_id' => 'A1' }]

      # Execute the transformation
      transform = Transform.new
      transform.transform_ads(api_data)

      # Verify that the data is correctly transformed and upserted in the database
      expect(Ads.find_by(id: '1')).to_not be_nil
    end
  end

  describe '#transform_ad_insights' do
    it 'transforms and upserts ad insights data correctly' do
      # Mock Facebook API data
      api_data = [{ 'clicks' => 100, 'ctr' => 0.1, 'inline_link_clicks' => 50, 'date_stop' => '2022-01-01',
                    'comments' => 5, 'spend' => 50.0, 'ad_id' => '1', 'account_id' => 'A1' }]

      # Execute the transformation
      transform = Transform.new
      transform.transform_ad_insights(api_data)

      # Verify that the data is correctly transformed and upserted in the database
      expect(AdMetrics.find_by(ad_id: '1')).to_not be_nil
    end
  end

  describe '#transform_ads' do
    context 'when the input data is missing required fields' do
      it 'raises an error' do
        data = [{ 'name' => 'Ad 1' }]

        # Execute the transformation
        transform = Transform.new
        expect { transform.transform_ads(data) }.to raise_error(ArgumentError)
      end
    end

    # Add more negative cases for this method
  end

  describe '#transform_ad_insights' do
    context 'when the input data contains invalid values' do
      it 'raises an error' do
        data = [{ 'clicks' => 'invalid', 'ctr' => 0.05 }]

        # Execute the transformation
        transform = Transform.new
        expect { transform.transform_ad_insights(data) }.to raise_error(ArgumentError)
      end
    end
  end
  # Add similar tests for other methods
end
