module AuthenticateHelper
  def auth_header(user = User.first)
    {'Authorization': auth_token(user)}
  end

  def expired_auth_header(user = User.first)
    {'Authorization': expired_token(user)}
  end

  private
    def auth_token(user = User.first)
      payload = {
        user_id: user.id
      }
      token = JsonWebToken.encode(payload)
      "Bearer #{token}"
    end

    def expired_token(user = User.first)
      payload = {
        user_id: user.id
      }
      token = JsonWebToken.encode(payload, 240.hours.ago)
      "Bearer #{token}"
    end
end
