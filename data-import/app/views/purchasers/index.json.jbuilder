json.array!(@purchasers) do |purchaser|
  json.extract! purchaser, :name
  json.url purchaser_url(purchaser, format: :json)
end
