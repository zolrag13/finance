require 'rails_helper'

RSpec.describe "HistoricalData", type: :request do
  describe "GET /historical_data" do
    it "works! (now write some real specs)" do
      get historical_data_path
      expect(response).to have_http_status(200)
    end
  end
end