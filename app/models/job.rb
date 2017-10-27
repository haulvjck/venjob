class Job < ApplicationRecord
  # include Impressionist::IsImpressionable

  # is_impressionable
  belongs_to :location
  belongs_to :company
  has_many :user_jobs
  has_many :job_industries

  FAVORITE = 'favorite'
  self.per_page = 20
  scope :jobs_by_city, -> (city_id) { joins(:location => :city).where({ cities: { id: city_id } }) }
  scope :jobs_by_industry, -> (industry_id) { joins(:job_industries => :industry).where({ industries: { id: industry_id } }) }

  scope :jobs_index_solr, -> {
    joins(
      :company, :location => :city, :job_industries => :industry
      )}#.select("`jobs`.`tilte`, `jobs`.`full_desc`, `companies`.`name`, `companies`.`indtroductions`, `locations`.`name`, `locations`.`country`, `locations`.`district`, `locations`.`address`, `industries`.`name`")}

  def address
    self.location.address
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
    self.location.city.id
  end

  def city_name
    self.location.city.name
  end

  # def self.all_job
  #   Job.includes(:company, :location => :city, :job_industries => :industry).select({jobs: {:job_tilte, :full_desc}, companies: {:name, :indtroductions}, locations: {:name, :country, :district, :address}, industries: {:name} }).all
  # end

end
