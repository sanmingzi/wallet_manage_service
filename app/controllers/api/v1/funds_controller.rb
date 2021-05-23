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
        out_wallet = User.find(out_user_id).wallet
        in_wallet = User.find(in_user_id).wallet
        if transact = out_wallet.transfer(in_wallet, amount)
          render json: {code: 0, balance: out_wallet.balance, transaction_id: transact.id}
        else
          render json: {code: 1, balance: out_wallet.balance}
        end
      end

      private
        def user_id
          params[:user_id]
        end

        def amount
          params[:amount].to_i
        end

        def out_user_id
          params[:out_user_id]
        end

        def in_user_id
          params[:in_user_id]
        end
    end
  end
end
