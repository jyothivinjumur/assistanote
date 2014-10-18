json.array!(@emails) do |email|
  json.extract! email, :id, :reference_id, :path
  json.url email_url(email, format: :json)
end
