class Merchant < ActiveRecord::Base
  has_many :purchases
  has_many :customers, through: :purchases, source: :purchaser
end