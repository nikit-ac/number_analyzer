# frozen_string_literal: true

# ::no-doc::
class User < ApplicationRecord
  has_secure_password

  # Validations
  validates_presence_of :login, :password_digest
  validates :login, uniqueness: true
  validates :password, :login, length: { in: 5..20 }
  validates :password_confirmation, presence: true, on: :create

  def self.from_token_request(request)
    # Returns a valid user, `nil` or raise
    # `Knock.not_found_exception_class_name` e.g.
    login = request.params['auth'] && request.params['auth']['login']
    find_by! login: login
  end
end
