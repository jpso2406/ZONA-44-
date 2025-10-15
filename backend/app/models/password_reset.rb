class PasswordReset < ApplicationRecord
  belongs_to :user
  validates :code, presence: true
  validates :expires_at, presence: true

  def expired?
    Time.current > expires_at
  end
end
