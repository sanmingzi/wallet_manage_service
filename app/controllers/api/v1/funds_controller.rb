module Api
  module V1
    class FundsController < ApplicationController
      def fund_in
        wallet = User.find(user_id).wallet
        transact = wallet.fund_in(amount)
        render json: {code: 0, balance: wallet.balance, transaction_id: transact.id}
      end

      def fund_out
        wallet = User.find(user_id).wallet
        if transact = wallet.fund_out(amount)
          render json: {code: 0, balance: wallet.balance, transaction_id: transact.id}
        else
          render json: {code: 1, balance: wallet.balance}
        end
      end

      def transfer
      end

      private
        def user_id
          params[:user_id]
        end

        def amount
          params[:amount].to_i
        end
    end
  end
end
