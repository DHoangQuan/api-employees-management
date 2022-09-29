# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                                                        :bigint           not null, primary key
#  address1                                                  :string
#  address2                                                  :string
#  allow_login                                               :boolean          default(FALSE)
#  display_name                                              :string           not null
#  email                                                     :string           default(""), not null
#  encrypted_password                                        :string           default(""), not null
#  first_name                                                :string           not null
#  last_name                                                 :string           not null
#  middle_name                                               :string
#  name_by_print_on_checks                                   :string
#  note                                                      :text
#  phone_number                                              :string
#  remember_created_at                                       :datetime
#  reset_password_sent_at                                    :datetime
#  reset_password_token                                      :string
#  role([0: supper_admin, 1:admin, 2: manager, 3: employee]) :integer          not null
#  title                                                     :string
#  created_at                                                :datetime         not null
#  updated_at                                                :datetime         not null
#
# Indexes
#
#  index_users_on_email                                           (email) UNIQUE
#  index_users_on_id_and_display_name_and_email_and_phone_number  (id,display_name,email,phone_number)
#  index_users_on_reset_password_token                            (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable

  has_many :user_companies
  has_many :companies, through: :user_companies
  has_many :working_times

  has_many :rates, class_name: 'UserRate', foreign_key: :resource_id

  scope :not_admin, -> { where.not(role: [ROLES[:supper_admin], ROLES[:admin]]) }

  ROLES = {
    supper_admin: 0,
    admin: 1,
    manager: 2,
    employee: 3
  }.freeze
end
