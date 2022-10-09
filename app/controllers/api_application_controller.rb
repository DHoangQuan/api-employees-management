# frozen_string_literal: true

# rubocop:disable Style/Documentation
class ApiApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_user!

  private

  def render_error(message: 'Bad Request', success: 'fail', status: 400)
    error_hash = {
      success: success,
      errors: message
    }

    render json: error_hash, status: status
  end
end
# rubocop:enable Style/Documentation
