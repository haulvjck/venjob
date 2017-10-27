class UserJob < ApplicationRecord
  belongs_to :user
  belongs_to :job

  TYPE = {
    :apply => 'apply',
    :favorite => 'favorite'
  }
end
