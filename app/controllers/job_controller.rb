class JobController < ApplicationController
  def index
    params[:page] = 1 unless params[:page]
    @search = params[:search] || ""

    @jobs = Job.includes(:location => :city).paginate(:page => params[:page])
  end

  def show
    @job = Job.includes(:location, :company, :job_industries => :industry).where(:id => params[:id]).first
  end

  def city
    if params[:city_id].nil?
      redirect_to jobs_path
    else
      city_id = params[:city_id].to_i
      @city_name = City.find(params[:city_id].to_i).name

      @jobs = Job.includes(:location => :city).jobs_by_city(city_id).paginate(:page => params[:page])
    end
  end

  def industry
    if params[:industry_id].nil?
      redirect_to jobs_path
    else
      industry_id = params[:industry_id].to_i

      @industry_name = Industry.find(industry_id).name
      @jobs = Job.includes(:location => :city, :job_industries => :industry).jobs_by_industry(industry_id).paginate(:page => params[:page])
    end
  end

  def favorite
    unless user_signed_in?
      redirect_to new_user_session_path
    else

    end
  end
end