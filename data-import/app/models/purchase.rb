class Purchase < ActiveRecord::Base
  belongs_to :purchaser
  belongs_to :merchant
end
