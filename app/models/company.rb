class Company < ActiveRecord::Base
  belongs_to :industry
  has_one :sector, :through => :industry
  has_many :historical_data
  has_many :subsidiaries_mergers, :class_name => 'Merger', :foreign_key => :acquiring_id
  has_one :parent_merger, :class_name => 'Merger', :foreign_key => :acquired_id
  has_one :parent, :through => :parent_merger, :source => :acquiring
  has_many :subsidiaries, :through => :subsidiaries_mergers, :source => :acquired
  has_one :companies_changes_from, :class_name => 'CompaniesChange', :foreign_key => :from_id
  has_one :became, :through => :companies_changes_from, :source => :to
  has_one :companies_changes_to, :class_name => 'CompaniesChange', :foreign_key => :to_id
  has_one :was, :through => :companies_changes_to, :source => :from

  validates :industry, :name, :symbol, presence: true

  def industry_name
    industry.name
  end

  def sector_name
    sector.name
  end

  def sector_id
    sector.id
  end

  def latest_historical_data
    historical_data.order('trade_date desc').limit(1)
  end

  def to_json
    {
        :id => id,
        :symbol => symbol,
        :name => name,
        :industry => industry.name,
        :sector => sector.name,
        :industry_id => industry_id,
        :sector_id => sector.id,
        :delisted => delisted,
        :inactive => !active,
        :liquidated => liquidated,
        :merged => merged?,
        :changed => became.present?,
        :details => details
    }
  end

  def merged?
    parent.present?
  end

  def details
    merger_msg.to_s + changes_msg.to_s + liquidated_msg.to_s + delisted_msg.to_s
  end

  def merger_msg
    msg = ''
    if parent.present?
      msg << "acquired by #{parent.name}"
    end
    if subsidiaries.present?
      msg << "subsidiaries: #{subsidiaries.map(&:name).join(', ')}"
    end
    msg
  end

  def changes_msg
    "became #{became.name}" if became.present?
  end

  def liquidated_msg
    'liquidated' if liquidated
  end

  def delisted_msg
    'delisted' if delisted
  end

end
