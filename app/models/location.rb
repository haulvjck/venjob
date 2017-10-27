class Location < ApplicationRecord
  belongs_to :city
  has_many :jobs
  has_many :companies

end
