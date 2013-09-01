class Item < ActiveRecord::Base
  belongs_to :merchant
  has_many :purchases

  validates :presence, :price, :merchant, presence: true
  validates :description, uniqueness: { scope: :merchant }
end
