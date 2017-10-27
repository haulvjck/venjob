class City < ApplicationRecord
  has_many :locations

  scope :city_by_country, -> (country_name) { joins(:locations).where( { locations: {country: country_name }}).distinct(:name) }
end
