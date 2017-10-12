class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :company_id
      t.string :name
      t.text :introductions
      t.references :location, index: true

      t.timestamps
    end
  end
end
