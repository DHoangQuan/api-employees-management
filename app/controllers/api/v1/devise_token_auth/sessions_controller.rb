# frozen_string_literal: true

module Api
  module V1
    module DeviseTokenAuth
      class SessionsController < ::DeviseTokenAuth::SessionsController
        skip_before_action :verify_authenticity_token

        def create
          user = User.new(resource_params)
          resource = User.find_by(email: user.email.downcase)

          if resource.present? && resource.allow_login
            super()
          else
            render json: {
              success: false,
              errors: ['Not Found User']
            }
          end
        end
      end
    end
  end
end
