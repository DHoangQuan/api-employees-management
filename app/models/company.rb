# frozen_string_literal: true

# == Schema Information
#
# Table name: companies
#
#  id                      :bigint           not null, primary key
#  address1                :string
#  address2                :string
#  display_name            :string           not null
#  email                   :string
#  name                    :string           not null
#  name_by_print_on_checks :string
#  note                    :text
#  phone_number            :string
#  tax                     :string
#  website                 :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_companies_on_id_and_name  (id,name)
#
class Company < ApplicationRecord
  has_many :user_companies
  has_many :users, through: :user_companies
  has_many :working_times

  has_many :rates, class_name: 'CompanyRate', foreign_key: :resource_id
end
