class JobIndustry < ApplicationRecord
  belongs_to :job
  belongs_to :industry

  def industry_name
    self.industry.name
  end

  def industry_id
    self.industry.id
  end

end