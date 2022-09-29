# frozen_string_literal: true

module RateSettingOperations
  # rubocop:disable Style/Documentation
  class Show
    def initialize(params)
      @params = params
    end

    def execute
      RateSetting.find_by_wkt_uuid(@params[:wkt_uuid])
    end
  end
  # rubocop:enable Style/Documentation
end
