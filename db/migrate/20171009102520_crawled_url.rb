class CrawledUrl < ActiveRecord::Migration[5.1]
  def change
    create_table :crawled_urls do |t|
      t.string :url

      t.timestamps
    end
  end
end
