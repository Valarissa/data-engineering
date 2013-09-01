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
    item = merchant.items.where(options['item']).first_or_create!
    purchase = item.purchases.create!(options['purchase'].merge(purchaser: purchaser))
    @purchases << purchase
    @total += (item.price * purchase.count.to_f)
  end

  ##
  # This method takes a rows' worth of data and creates a Hash by zipping it
  # together with the key. This gives us a hash like:
  #
  #   {'item_price' => 10.0, 'item_description' => 'I\'m being described!'...}
  #
  # After preparing that, we then take all of the keys, break them apart into
  # a model name and an attribute (e.g. 'item', 'price') and then re-creates
  # the hash to be more like:
  #
  #   {'item' => {'price' => 10.0, 'description' => 'I\'m being described!'}...}
  #
  # These can then be used in the appropriate #where methods like:
  #
  #   Item.where(options['item']).first_or_create!
  #
  # This allows this importer to basically be able to add arbitrary attributes
  # to models as long as the column names are of the #{model}_#{attribute}
  # format and the database has the appropriate columns.
  #
  # Also, it was fun to do this.
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
