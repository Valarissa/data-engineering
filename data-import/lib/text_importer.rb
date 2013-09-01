class TextImporter
  attr_reader :errors, :key, :purchases, :total
  extend ActiveModel::Naming

  def initialize
    @errors = ActiveModel::Errors.new(self)
    @purchases = []
    @total = 0.0
  end

  def read_attribute_for_validation(attribute)
    send(attribute)
  end

  def self.human_attribute_name(attribute, options={})
    attribute
  end

  def self.lookup_ancestors
    [self]
  end

  def import_from_file(file)
    return if file.eof?
    create_key(columns_from(file.readline))
    ActiveRecord::Base.transaction do
      file.each_line do |line|
        create_record(columns_from(line))
      end
    end

    self
  end

  private

  def create_key(columns)
    @key = columns.map{|item| item.strip.gsub(/\s/, '_')}
  end

  def create_record(columns)
    options = prepare_options(columns)

    merchant = Merchant.where(options['merchant']).first_or_create!
    purchaser = Purchaser.where(options['purchaser']).first_or_create!
    item = Item.where(options['item'].merge(merchant: merchant)).first_or_create!
    purchase = Purchase.create!(options['purchase'].merge(item: item, merchant: merchant, purchaser: purchaser))
    @purchases << purchase
    @total += (item.price * purchase.count.to_f)
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
