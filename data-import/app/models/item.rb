class Item < ActiveRecord::Base
  belongs_to :merchant

  validates :presence, :price, :merchant, presence: true
  validates :description, uniqueness: { scope: :merchant }
end
