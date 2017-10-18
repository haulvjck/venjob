class CityController < ApplicationController
  def index
    @vn_cities = City.joins(:locations).where("`country` like 'VietNam'").distinct(:name)

    @inter_cities = City.limit 3
  end
end