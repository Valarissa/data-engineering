require 'active_record_spec_helper'
require 'text_importer'
require 'purchase'
require 'purchaser'
require 'merchant'
require 'item'

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

    it 'creates a Purchaser as needed for each line' do
      expect{importer.import_from_file(file)}.to change{Purchaser.count}.from(0).to(3)
      expect(Purchaser.where(name: 'Snake Plissken').first.purchases.count).to eq(2)
    end

    it 'creates a Merchant as needed for each line' do
      expect{importer.import_from_file(file)}.to change{Merchant.count}.from(0).to(3)
      expect(Merchant.where(address: '123 Fake St').first.customers.map(&:name)).to eq(['Marty McFly', 'Snake Plissken'])
    end

    it 'creates an Item as needed for each line' do
      expect{importer.import_from_file(file)}.to change{Item.count}.from(0).to(3)
    end

    it 'reports the total amount of gross revenue represented in the file' do
      expect{importer.import_from_file(file)}.to change{importer.total}.from(0).to(95.0)
    end
  end
end
