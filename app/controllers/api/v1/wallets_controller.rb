module Api
  module V1
    class WalletsController < ApplicationController
      def balance
        wallet = User.find(user_id).wallet
        render json: {code: 0, balance: wallet.balance}
      end

      private
        def user_id
          params[:user_id]
        end
    end
  end
end
