class CreateUserJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :user_jobs do |t|
      t.references :user, index: true
      t.references :job, index: true
      t.string :user_job_relative_type

      t.timestamps
    end
  end
end
