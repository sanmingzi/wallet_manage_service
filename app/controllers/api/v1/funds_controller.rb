module Api
  module V1
    class FundsController < ApplicationController
      def fund_in
        # wallet = User.find(user_id).wallet
        # transaction = nil
        # transaction do
        #   wallet.fund_in(fund)
        #   transaction = FundInTransaction.new()
        #   # FundTransaction.create
        # end
        # render json: {code: 0, balance: wallet.balance, transaction_id: }
      end

      def fund_out
      end

      def transfer
      end

      private
        def user_id
          params[:user_id]
        end

        def fund
          params[:fund]
        end
    end
  end
end
