class CreateJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :jobs do |t|
      t.text :name
      t.string :title
      t.string :short_title
      t.string :short_desc
      t.text :full_desc
      t.references :location, index: true
      t.references :company, index: true
      t.string :contact_email
      t.string :contact_name
      t.string :contact_phone
      t.string :salary
      t.text :benefit

      t.timestamps
    end
  end
end
