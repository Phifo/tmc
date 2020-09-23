# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from 'StandardError' do |exception|
    render json: {
      errors: [{
        status: 500,
        detail: exception.message
      }]
    }, status: :internal_server_error
  end

  rescue_from 'ActiveModel::ValidationError' do |exception|
    render json: {
      errors: [{
        status: 400,
        detail: exception.message
      }]
    }, status: :bad_request
  end

  rescue_from 'ActionController::RoutingError' do |exception|
    render json: {
      errors: [{
        status: 404,
        detail: exception.message
      }]
    }, status: :not_found
  end
end
