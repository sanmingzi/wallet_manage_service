class ApplicationController < ActionController::API
  class AuthenticateError < StandardError; end

  include ActionController::Helpers

  before_action :set_current_user
  before_action :authenticate!

  helper_method :current_user, :authenticated?

  rescue_from AuthenticateError, with: :not_authenticated
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def current_user
    @current_user
  end

  def authenticated?
    @current_user != nil
  end

  private
    def set_current_user
      @current_user ||= (current_user_id && User.find(current_user_id))
    end

    def authenticate!
      unless authenticated?
        Rails.logger.info "authenticate failed, auth_header: #{auth_header}, decoded_auth_token: #{decoded_auth_token}"
        raise AuthenticateError
      end
    end

    def auth_header
      request.headers['Authorization']
    end

    def decoded_auth_token
      if auth_header
        token = auth_header.split(' ').last
        @decoded_auth_token ||= JsonWebToken.decode(token)
      end
    end

    def current_user_id
      decoded_auth_token && decoded_auth_token['user_id']
    end

    def not_authenticated
      render json: {code: 401}, status: :unauthorized
    end

    def record_not_found
      render json: {code: 404}, status: :not_found
    end
end
