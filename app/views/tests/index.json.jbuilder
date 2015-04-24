json.array!(@tests) do |test|
  json.extract! test, :id, :result
  json.url test_url(test, format: :json)
end
