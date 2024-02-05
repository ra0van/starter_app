# frozen_string_literal: true

class Users < ApplicationRecord
  has_many :ad_accounts
end
