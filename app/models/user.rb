class User < ApplicationRecord
  has_many :user_jobs

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def favorite_count
    self.user_jobs.where(:user_job_relative_type => Job::FAVORITE).count
  end

  def history

  end
end
