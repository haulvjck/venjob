class Users::MyPageController < ApplicationController

  def index
    @jobs = Job.limit(10)
  end

  def favorite
    @jobs = Job.limit(10)
  end

  def history
    @jobs = Job.limit(10)
  end
end