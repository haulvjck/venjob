class Job < ApplicationRecord
  belongs_to :location
  belongs_to :company
  has_many :user_jobs
  has_many :job_industries
end
