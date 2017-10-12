class CityController < ActionController::Base
  def index
    @vn_cities = City.joins(:locations).where("`country` like 'VietNam'").distinct(:name)

    @inter_cities = City.limit 3
  end

  def show
    @city = City.where(:id => params[:id]).first
  end
end