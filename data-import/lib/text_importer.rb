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
    @key = columns.map{|item| item.strip.gsub(/\s/, '_')}
  end

  def create_record(columns)
    options = prepare_options(columns)

    merchant = Merchant.where(options['merchant']).first_or_create
    purchaser = Purchaser.where(options['purchaser']).first_or_create
    item = Item.where(options['item'].merge(merchant: merchant)).first_or_create
    Purchase.create(options['purchase'].merge(item: item, merchant: merchant, purchaser: purchaser))
  end

  def prepare_options(columns)
    options = Hash[key.zip(columns)]
    options.keys.each do |key|
      model, attribute = key.split('_')
      options[model] ||= {}
      options[model][attribute] = options.delete(key)
    end

    options
  end

  def columns_from(input)
    input.split("\t")
  end
end
