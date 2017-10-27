class ChangeShortDescFormatInJobTable < ActiveRecord::Migration[5.1]
  def change
    change_column :jobs, :short_desc, :text
  end
end
