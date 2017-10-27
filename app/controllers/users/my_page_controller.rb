class Users::MyPageController < ApplicationController

  def index
    @jobs = Job.limit(10)
  end

  def favorite
    unless user_signed_in?
      redirect_to new_user_session_path
    else
      @jobs = Job.limit(10)
    end
  end

  def history
    job_ids = if user_signed_in?
      current_user.history_job_ids
    else
      Impression.where(:session_hash => session['session_id']).distinct(:impressionable_id).order(created_at: :desc).limit(20).collect { |i| i.impressionable_id }
    end

    @jobs = Job.find(job_ids)
  end

  def info
  end
end