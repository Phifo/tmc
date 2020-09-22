# frozen_string_literal: true

module SbifAPI
  class TMCAdapter
    include ActiveModel::Validations

    attr_accessor :loan_amount, :loan_term, :date

    validates :loan_amount, presence: true, numericality: true
    validates :loan_term, presence: true, numericality: { only_integer: true }
    validates :date, format: { with: /[0-9]{4}-[0-9]{2}-[0-9]{2}/ }

    def initialize(args)
      args.each { |name, value| instance_variable_set("@#{name}", value) }
    end
  end
end
