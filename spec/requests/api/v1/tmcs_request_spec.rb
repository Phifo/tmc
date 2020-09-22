# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Tmcs', type: :request do
  describe 'GET /api/v1/tmcs' do
    context 'with loan term less than or equal to 3 months' do
      let(:loan_term) { 2 }

      context 'with loan amount less than or equal to 5000 UF' do
        let(:loan_amount) { 5000 }

        it 'retrieves the tmc percentage' do
          expected_response = { tmc: 35.04 }

          get api_v1_tmc_url
          expect(response.body).to include_json(expected_response)
        end
      end

      context 'with loan amount greater than 5000 UF' do
        let(:loan_amount) { 5001 }

        it 'retrieves the tmc percentage' do
          expected_response = { tmc: 6.81 }

          get api_v1_tmc_url
          expect(response.body).to include_json(expected_response)
        end
      end
    end

    context 'with loan term greater than or equal to 3 months' do
      let(:loan_term) { 3 }

      context 'with loan amount less than or equal to 50 UF' do
        let(:loan_amount) { 50 }

        it 'retrieves the tmc percentage' do
          expected_response = { tmc: 33.8 }

          get api_v1_tmc_url
          expect(response.body).to include_json(expected_response)
        end
      end

      context 'with loan amount greater than 50 UF and less than or equal to 200 UF' do
        let(:loan_amount) { 51 }

        it 'retrieves the tmc percentage' do
          expected_response = { tmc: 26.8 }

          get api_v1_tmc_url
          expect(response.body).to include_json(expected_response)
        end
      end

      context 'with loan amount greater than 200 UF and less than or equal to 5000 UF' do
        let(:loan_amount) { 201 }

        it 'retrieves the tmc percentage' do
          expected_response = { tmc: 19.2 }

          get api_v1_tmc_url
          expect(response.body).to include_json(expected_response)
        end
      end

      context 'with loan amount greater than 5000 UF' do
        let(:loan_amount) { 5001 }

        it 'retrieves the tmc percentage' do
          expected_response = { tmc: 4.97 }

          get api_v1_tmc_url
          expect(response.body).to include_json(expected_response)
        end
      end
    end
  end
end
