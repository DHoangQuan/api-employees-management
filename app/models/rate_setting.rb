# frozen_string_literal: true

# == Schema Information
#
# Table name: rate_settings
#
#  id         :bigint           not null, primary key
#  wkt_uuid   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rate_id    :bigint
#
# Indexes
#
#  index_rate_settings_on_wkt_uuid  (wkt_uuid)
#
class RateSetting < ApplicationRecord
  belongs_to :rate, optional: true
end
