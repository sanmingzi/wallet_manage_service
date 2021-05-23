module AuthenticateHelper
  def auth_header
    {'Authorization': auth_token}
  end

  def auth_token(user = User.first)
    payload = {
      user_id: user.id
    }
    token = JsonWebToken.encode(payload)
    "Bearer #{token}"
  end

  def expired_auth_header
    {'Authorization': expired_token}
  end

  def expired_token(user = User.first)
    payload = {
      user_id: user.id
    }
    token = JsonWebToken.encode(payload, 240.hours.ago)
    "Bearer #{token}"
  end
end
