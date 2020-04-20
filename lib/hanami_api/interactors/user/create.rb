# frozen_string_literal: true

require 'hanami/interactor'

class User::Create
  include Hanami::Interactor
  expose :user

  def initialize(repository: UserRepository.new)
    @repository = repository
  end

  def call(user_attributes)
    encrypted_user_attributes = encrypt(user_attributes)
    @repository.create(encrypted_user_attributes)
  end

  private

  def encrypt(attributes)
    password_digest = BCrypt::Password.create(attributes[:password])
    attributes = attributes.merge(password_digest: password_digest)
    attributes.delete(:password)
    attributes
  end
end