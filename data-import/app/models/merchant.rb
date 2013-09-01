class Merchant < ActiveRecord::Base
  has_many :items
  has_many :purchases, through: :items
  has_many :customers, through: :purchases, source: :purchaser

  validates :name, :address, presence: true
end
