class Purchase < ActiveRecord::Base
  belongs_to :purchaser
  belongs_to :merchant
  belongs_to :item

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
