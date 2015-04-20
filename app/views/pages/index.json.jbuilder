json.array!(@pages) do |page|
  json.extract! page, :id, :description
  json.url page_url(page, format: :json)
end
