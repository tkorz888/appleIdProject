json.extract! user, :id, :login, :password_digest, :state, :is_admin, :created_at, :updated_at
json.url user_url(user, format: :json)