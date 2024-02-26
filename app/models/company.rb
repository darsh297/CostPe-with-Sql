class Company < ApplicationRecord
  has_many :users
  has_many :projects, through: :users
  has_many :holidays

end
