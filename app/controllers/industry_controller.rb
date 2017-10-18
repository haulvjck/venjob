class IndustryController < ApplicationController
  def index
    @industries = Industry.all
  end

end