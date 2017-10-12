class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.text :country
      t.references :city, index: true
      t.string :district
      t.string :address

      t.timestamps
    end
  end
end
