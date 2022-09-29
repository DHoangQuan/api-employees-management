# frozen_string_literal: true

# == Schema Information
#
# Table name: working_times
#
#  id           :bigint           not null, primary key
#  display_name :string
#  e_ot_money   :float
#  e_reg_money  :float
#  friday       :string
#  i_ot_money   :float
#  i_reg_money  :float
#  monday       :string
#  note         :text
#  saturday     :string
#  sunday       :string
#  thursday     :string
#  total_hours  :float
#  tuesday      :string
#  uuid         :string           not null
#  wednesday    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :bigint           not null
#  rate_id      :bigint
#  user_id      :bigint
#  week_id      :bigint           not null
#
# Indexes
#
#  index_working_times_on_display_name_and_uuid  (display_name,uuid)
#
class WorkingTime < ApplicationRecord
  belongs_to :company
  belongs_to :week
  belongs_to :user, optional: true
  belongs_to :rate, optional: true

  REPORT_TYPE_METHOD = {
    internal: 'WorkingTimeOperations::ExportInternal',
    external: 'WorkingTimeOperations::ExportExternal'
  }.freeze
end
