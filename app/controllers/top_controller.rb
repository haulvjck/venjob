class TopController < ApplicationController
  def index
    @favorite_count = current_user.favorite_count if current_user
    @top_cities = City.joins(:locations => :jobs).select("cities.id, cities.name, count(*) job_count").group("cities.id, cities.name").order("count(*) desc").limit 9
    @all_city = City.count

    @top_industries = Industry.joins(:job_industries).select("industries.id, industries.name, count(*) job_count").group("industries.id, industries.name").order("count(*) desc").limit 9
    @all_industry = Industry.count

    # @favorites = 69
    @latest_jobs = Job.includes(:location => :city).order(created_at: :desc).limit(5)
    @total_jobs = Job.count
  end

end
