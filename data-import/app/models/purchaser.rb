class Purchaser < ActiveRecord::Base
  has_many :purchases

  validates :name, presence: true
end
