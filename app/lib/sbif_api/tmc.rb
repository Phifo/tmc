# frozen_string_literal: true

module SbifAPI
  class TMC
    API_KEY = ENV['SBIF_API_KEY']
    BASE_URL = 'https://api.sbif.cl/api-sbifv3/recursos_api/tmc'
    LOAN_TERM_LIMIT = 3
    LOAN_AMOUNT_50 = 50.0
    LOAN_AMOUNT_200 = 200.0
    LOAN_AMOUNT_5000 = 5000.0

    attr_reader :loan_amount, :loan_term

    def initialize(tmc_adapter)
      @loan_amount = tmc_adapter.loan_amount.to_f
      @loan_term = tmc_adapter.loan_term.to_i
    end

    def tmc_value(date)
      query_date = date
      tmc_response = nil

      while tmc_response.blank? || date < tmc_response['Fecha'].to_date
        tmc_response = tmc_request(query_date)
        query_date -= 1.month
      end

      tmc_response['Valor'].to_f
    end

    private

    def tmc_request(date)
      url = generate_url(date)

      response = Faraday.get(url)
      json_response = JSON.parse(response.body)

      if response.status == 404
        raise ActionController::RoutingError, json_response['Mensaje']
      end

      json_response['TMCs'].select { |tmc| tmc['Tipo'] == type }.first
    end

    def generate_url(date)
      year = date.year
      month = date.strftime('%m')

      "#{BASE_URL}/#{year}/#{month}?apikey=#{API_KEY}&formato=json"
    end

    def type
      if @loan_term < LOAN_TERM_LIMIT
        type_lt_loan_term_limit
      else
        type_gte_loan_term_limit
      end
    end

    # these are type codes from SBIF API
    # https://api.sbif.cl/documentacion/TMC.html
    def type_lt_loan_term_limit
      if @loan_amount <= LOAN_AMOUNT_5000
        '26'
      else
        '25'
      end
    end

    def type_gte_loan_term_limit
      if @loan_amount <= LOAN_AMOUNT_50
        '45'
      elsif @loan_amount > LOAN_AMOUNT_50 && @loan_amount <= LOAN_AMOUNT_200
        '44'
      elsif @loan_amount > LOAN_AMOUNT_200 && @loan_amount <= LOAN_AMOUNT_5000
        '35'
      else
        '34'
      end
    end
  end
end
