class JobIndustries < ActiveRecord::Migration[5.1]
  def change
    create_table :job_industries do |t|
      t.references :job, index: true
      t.references :industry, index: true

      t.timestamps
    end
  end
end
