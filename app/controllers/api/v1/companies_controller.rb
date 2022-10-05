# frozen_string_literal: true

module Api
  module V1
    class CompaniesController < ApiApplicationController
      def index
        rs = CompanyOperations::Index.new(params).execute
      end
    end
  end
end
