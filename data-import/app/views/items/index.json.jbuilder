json.array!(@items) do |item|
  json.extract! item, :merchant_id, :description, :price
  json.url item_url(item, format: :json)
end
