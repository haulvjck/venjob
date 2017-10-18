class Job < ApplicationRecord
  belongs_to :location
  belongs_to :company
  has_many :user_jobs
  has_many :job_industries

  self.per_page = 20
  scope :jobs_by_city, -> (city_id) { joins(:location => :city).where({ cities: { id: city_id } }) }
  scope :jobs_by_industry, -> (industry_id) { joins(:job_industries => :industry).where({ industries: { id: industry_id } }) }

  def address
    self.location.get_address
  end

  def industries
    self.job_industries.collect { |ind| ind.industry }.uniq
  end

  def company_name
    self.company.name
  end

  def company_id
    self.company.id
  end

  def city_id
    self.location.city_id
  end

  def city_name
    self.location.city_name
  end
end
