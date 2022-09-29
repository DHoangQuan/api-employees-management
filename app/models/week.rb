# frozen_string_literal: true

# == Schema Information
#
# Table name: weeks
#
#  id         :bigint           not null, primary key
#  from_date  :date
#  to_date    :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_weeks_on_from_date  (from_date)
#
class Week < ApplicationRecord
  has_many :working_times
end
