class ExportJob < ApplicationRecord
  scope:  UserJob.select('jobs.title "Job Title", users.full_name "Candidate Name", users.email "Candidate Email", users.cv_path "Candidate CV", user_jobs.created_at "Apply at"').joins(:user, :job).where("users.id = user_jobs.user_id and user_jobs.job_id = jobs.id").all
end