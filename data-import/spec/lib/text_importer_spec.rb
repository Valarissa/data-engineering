require 'active_record_spec_helper'
require 'text_importer'
require 'purchase'

describe TextImporter do
  describe 'text import process' do
    let(:file) { File.open('spec/support/test_input.txt') }
    let(:importer) { TextImporter.new }

    it 'does nothing for a blank file input' do
      file = File.new('blank_file', 'w+')
      expect(importer.import_from_file(file)).to eq(nil)
      File.delete(file)
    end

    it 'creates a key from the first line' do
      expect{importer.import_from_file(file)}.to change{importer.key}.to(['purchaser_name', 'item_description', 'item_price', 'purchase_count', 'merchant_address', 'merchant_name'])
    end

    it 'creates a Purchase for each line' do
      expect{importer.import_from_file(file)}.to change{Purchase.count}.from(0).to(4)
    end
  end
end
