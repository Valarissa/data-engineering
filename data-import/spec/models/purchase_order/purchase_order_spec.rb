require 'active_record_spec_helper'
require 'purchase_order'

describe PurchaseOrder do
  describe 'text import process' do
    it 'does nothing for a blank file input' do
      file = File.new('blank_file', 'w+')
      expect(PurchaseOrder.import_from_text_file(file)).to eq(nil)
      File.delete(file)
    end
  end
end
