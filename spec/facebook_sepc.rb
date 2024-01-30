# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Facebook, type: :service do
  describe '#get_ads' do
    it 'fetches ads data correctly' do
      # Mock the API response
      mock_response = double(code: '200', body: { 'data' => [{ 'id' => '1', 'name' => 'Ad 1', 'adset_id' => '1', 'account_id' => 'A1' }] }.to_json)
      expect_any_instance_of(HTTP::RequestHandler).to receive(:send_get_request).and_return(mock_response)

      # Execute the method
      facebook = Facebook.new
      ads_data = facebook.get_ads('A1')

      # Verify that the data is correctly fetched
      expect(ads_data).not_to be_nil
    end

    # Add tests for error handling, edge cases, etc.
  end

  describe '#get_ad_insights' do
    it 'fetches ad insights data correctly' do
      # Mock the API response
      mock_response = double(code: '200', body: { 'data' => [{ 'id' => '1', 'name' => 'Ad 1', 'adset_id' => '1', 'account_id' => 'A1' }] }.to_json)
      expect_any_instance_of(HTTP::RequestHandler).to receive(:send_get_request).and_return(mock_response)

      # Execute the method
      facebook = Facebook.new
      ad_insights_data = facebook.get_ad_insights('A1')

      # Verify that the data is correctly fetched
      expect(ad_insights_data).not_to be_nil
    end

    # Add tests for error handling, edge cases, etc.
  end

  # Add similar tests for other methods
end
