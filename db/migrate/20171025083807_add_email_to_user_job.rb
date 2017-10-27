class AddEmailToUserJob < ActiveRecord::Migration[5.1]
  def change
    add_column :user_jobs, :candidate_email, :string
    add_column :user_jobs, :candidate_name, :string
    add_column :user_jobs, :cv_path, :string
  end
end
