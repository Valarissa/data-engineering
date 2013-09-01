class Purchase < ActiveRecord::Base
  belongs_to :purchaser
  belongs_to :item
  has_one :merchant, through: :item

  validates :purchaser, :item, presence: true
  validates :count, numericality: { greater_than: 0 }

  def total
    (item.price * count.to_f)
  end

  def self.grand_total(purchases)
    total = 0.0
    purchases.each do |purchase|
      total += purchase.total
    end

    format("%.2f", total)
  end
end
