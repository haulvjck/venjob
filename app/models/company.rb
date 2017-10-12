class Company < ApplicationRecord
  belongs_to :location
  has_many :jobs
end
