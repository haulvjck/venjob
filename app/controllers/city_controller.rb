class CityController < ApplicationController
  def index
    @vn_cities = City.includes(:locations).city_by_country('VietNam')

    @inter_cities = City.includes(:locations).city_by_country('International')
  end
end