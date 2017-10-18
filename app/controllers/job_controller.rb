class JobController < ApplicationController
  def index
    params[:page] = 1 unless params[:page]
    search = params[:search] || ""

    jobs = Job.includes(:location => :city).paginate(:page => params[:page])
    render partial: 'form_template/job_template', :locals => {jobs: jobs, search: search}
  end

  def show
    @job = Job.includes(:location, :company, :job_industries => :industry).where(:id => params[:id]).first
  end

  def city
    if params[:city_id].nil?
      redirect_to jobs_path
    else
      city_id = params[:city_id].to_i

      jobs = Job.includes(:location => :city).jobs_by_city(city_id).paginate(:page => params[:page])

      render partial: 'form_template/job_template', :locals => {jobs: jobs, search: City.find(params[:city_id].to_i).name}
    end
  end

  def industry
    if params[:industry_id].nil?
      redirect_to jobs_path
    else
      industry_id = params[:industry_id].to_i

      jobs = Job.includes(:location => :city, :job_industries => :industry).jobs_by_industry(industry_id).paginate(:page => params[:page])

      render partial: 'form_template/job_template', :locals => {jobs: jobs, search: Industry.find(industry_id).name}
    end
  end
end