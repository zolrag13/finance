class HistoricalDatum < ActiveRecord::Base
  belongs_to :company

  validates :company, :trade_date, :open, :high, :low, :close, :volume, :adjusted_close, presence: true

  def trade_date_as_timestamp
    trade_date.to_time.to_i * 1000
  end
end
