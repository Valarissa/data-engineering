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
    Purchase.create(item_id: 1, merchant_id: 1, purchaser_id: 1, count: options[:purchase_count])
  end

  def columns_from(input)
    input.split("\t")
  end
end
