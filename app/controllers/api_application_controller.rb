# frozen_string_literal: true

class ApiApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action authenticate_api_v1_user!
end
