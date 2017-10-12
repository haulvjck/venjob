class User < ApplicationRecord
  has_many :user_jobs

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
