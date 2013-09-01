json.array!(@merchants) do |merchant|
  json.extract! merchant, :name, :address
  json.url merchant_url(merchant, format: :json)
end
