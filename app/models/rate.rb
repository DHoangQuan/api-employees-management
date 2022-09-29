# frozen_string_literal: true

# == Schema Information
#
# Table name: rates
#
#  id                                               :bigint           not null, primary key
#  external_ot                                      :float
#  external_regular                                 :float
#  holiday_rate                                     :float
#  internal_ot                                      :float
#  internal_regular                                 :float
#  status([0: current, 1:past])                     :integer          default(0), not null
#  type                                             :string           not null
#  created_at                                       :datetime         not null
#  updated_at                                       :datetime         not null
#  company_id(Check if user rates of which company) :bigint
#  resource_id                                      :bigint           not null
#
# Indexes
#
#  index_rates_on_type_and_resource_id  (type,resource_id)
#
class Rate < ApplicationRecord
  belongs_to :company, optional: true
  belongs_to :user, optional: true

  has_many :rate_settings

  scope :current_using, -> { find_by status: COLUMN_STATUS[:current] }

  COLUMN_STATUS = {
    current: 0,
    past: 1
  }.freeze

  RESOURCES = {
    company: 'company',
    user: 'user'
  }.freeze
end
