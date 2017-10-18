class Location < ApplicationRecord
  belongs_to :city
  has_many :jobs
  has_many :companies

  def get_address
    [self.address, self.district, self.city.name].compact.join(", ")
  end

  def city_name
    self.city.name
  end

  def city_id
    self.city.id
  end
end
