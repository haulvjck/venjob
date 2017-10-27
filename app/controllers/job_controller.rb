class JobController < ApplicationController
  impressionist actions: [:show]

  def index
    @search = params[:search] || ""

    @jobs = Job.includes(:location => :city).paginate(:page => params[:page])
  end

  def show
    @job = Job.find(params[:id])
    # user_id = user_signed_in? ? current_user.id : ANONYMOUS_ID
    # UserJob.create(:user_id => current_user.id, :job_id => params[:id]) if
  end

  def city
    redirect_to jobs_path if params[:city_id].blank?

    city_id = params[:city_id].to_i
    @city_name = City.find(city_id).name

    @jobs = Job.includes(:location => :city).jobs_by_city(city_id).paginate(:page => params[:page])
  end

  def industry
    redirect_to jobs_path if params[:industry_id].blank?

    industry_id = params[:industry_id].to_i

    @industry_name = Industry.find(industry_id).name
    @jobs = Job.includes(:location => :city, :job_industries => :industry).jobs_by_industry(industry_id).paginate(:page => params[:page])
  end

  def apply
    redirect_to new_user_session_path unless user_signed_in?
    redirect_to top_index_path if params[:job_id].blank?

    @job_id = params[:job_id]
  end

  def confirm
  end

  def finish_apply
    @apply_full_name = params['confirm_info']['full_name']
    @apply_email = params['confirm_info']['email']
    @apply_cv = params['confirm_info']['cv_path']
    @job_id = params['confirm_info']['job_id']

    if params[:commit] == 'Edit'
      render 'job/apply'
    else
      UserJob.create!(
        user_id: current_user.id,
        job_id: @job_id,
        candidate_email: @apply_email,
        candidate_name: @apply_full_name,
        cv_path: @apply_cv,
        user_job_relative_type: UserJob::TYPE[:apply]
      )

      job = Job.find(@job_id)
      email_params = {
        email: current_user.email,
        apply_email: @apply_email,
        full_name: @apply_full_name,
        job_title: job.title,
        location: job.address,
        company: job.company_name,
        cv_path: @apply_cv
      }

      UserMailer.apply_job_email(email_params).deliver_now
    end
  end

end