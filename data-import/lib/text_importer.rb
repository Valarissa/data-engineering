class TextImporter
  attr_reader :key

  def import_from_file(file)
    return if file.eof?
    create_key(columns_from(file.readline))
    file.each_line do |line|
      create_record(columns_from(line))
    end
  end

  private

  def create_key(columns)
    @key = columns.map{|item| item.gsub("\n", '').gsub(/\s/, '_')}
  end

  def create_record(columns)
    options = Hash[key.zip(columns)]
    merchant = Merchant.where(name: options['merchant_name'], address: options['merchant_address']).first_or_create
    item = Item.where(merchant: merchant, description: options['item_description'], price: options['item_price']).first_or_create
    purchaser = Purchaser.where(name: options['purchaser_name']).first_or_create
    Purchase.create(item: item, merchant: merchant, purchaser: purchaser, count: options[:purchase_count])
  end

  def columns_from(input)
    input.split("\t")
  end
end
