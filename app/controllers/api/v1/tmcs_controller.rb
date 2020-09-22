# frozen_string_literal: true

module Api
  module V1
    class TmcsController < ApplicationController
      def tmc
        tmc_adapter = SbifAPI::TMCAdapter.new(tmc_params)
        tmc_adapter.validate!

        tmc_service = SbifAPI::TMC.new(tmc_adapter)
        tmc_value = tmc_service.tmc_value(tmc_adapter.date.to_date)

        render json: {
          loan_amount: tmc_service.loan_amount,
          loan_term: tmc_service.loan_term,
          date: tmc_adapter.date,
          tmc: tmc_value
        }
      end

      private

      def tmc_params
        params.permit(:loan_term, :loan_amount, :date)
      end
    end
  end
end
