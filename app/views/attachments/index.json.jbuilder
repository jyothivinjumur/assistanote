json.array!(@attachments) do |attachment|
  json.extract! attachment, :id, :reference_id, :path, :email_id
  json.url attachment_url(attachment, format: :json)
end
