# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Tmcs', type: :request do
  describe 'GET /api/v1/tmcs' do
    shared_examples 'tmc' do
      it 'retrieves correct tmc value' do
        get api_v1_tmc_url, params: { loan_term: loan_term, loan_amount: loan_amount, date: date }

        expect(response.body).to include_json(expected_response)
      end
    end

    before do
      response = double('response', status: 200, body: file_fixture('sbif_response.json').read)
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(response)
    end

    let(:date) { '2020-08-14' }

    context 'with loan term less than or equal to 3 months' do
      let(:loan_term) { 2 }

      context 'with loan amount less than or equal to 5000 UF' do
        let(:loan_amount) { 5000 }
        let(:expected_response) { { tmc: 35.04 } }

        include_examples 'tmc'
      end

      context 'with loan amount greater than 5000 UF' do
        let(:loan_amount) { 5001 }
        let(:expected_response) { { tmc: 6.81 } }

        include_examples 'tmc'
      end
    end

    context 'with loan term greater than or equal to 3 months' do
      let(:loan_term) { 3 }

      context 'with loan amount less than or equal to 50 UF' do
        let(:loan_amount) { 50 }
        let(:expected_response) { { tmc: 33.8 } }

        include_examples 'tmc'
      end

      context 'with loan amount greater than 50 UF and less than or equal to 200 UF' do
        let(:loan_amount) { 51 }
        let(:expected_response) { { tmc: 26.8 } }

        include_examples 'tmc'
      end

      context 'with loan amount greater than 200 UF and less than or equal to 5000 UF' do
        let(:loan_amount) { 201 }
        let(:expected_response) { { tmc: 19.2 } }

        include_examples 'tmc'
      end

      context 'with loan amount greater than 5000 UF' do
        let(:loan_amount) { 5001 }
        let(:expected_response) { { tmc: 4.97 } }

        include_examples 'tmc'
      end
    end
  end
end
