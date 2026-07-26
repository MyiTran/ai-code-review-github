# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  avatar_url             :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           default(""), not null
#  github_access_token    :text
#  github_username        :string
#  last_name              :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  provider               :string
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default(0), not null
#  sign_in_count          :integer          default(0), not null
#  uid                    :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_provider_and_uid      (provider,uid) UNIQUE WHERE ((provider IS NOT NULL) AND (uid IS NOT NULL))
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Allowlist

  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :validatable, :trackable,
         :jwt_authenticatable, :omniauthable, omniauth_providers: [:github], jwt_revocation_strategy: self

  has_one_attached :avatar

  enum :role, {
    member: 0,
    admin: 1
  }

  encrypts :github_access_token

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :uid,
            uniqueness: { scope: :provider },
            allow_nil: true

  validates :avatar,
            content_type: Constants::UPLOADED_FILE_CONTENT_TYPES,
            size: {
              less_than_or_equal_to:
                Constants::UPLOADED_FILE_MAX_SIZE
            }
end
