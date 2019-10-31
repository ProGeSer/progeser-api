# frozen_string_literal: true

if Rails.env.development?
  require 'database_cleaner'
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean

  # Doorkepper::Applications
  Doorkeeper::Application.create!(
    name: 'Doorkeeper Application',
    redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
    confidential: false
  )

  # Users
  Users::Requester.create!(
    role: :requester,
    email: 'dev+requester@progeser.com',
    password: 'password',
    password_confirmation: 'password',
    first_name: 'Requester',
    last_name: 'ProGeSer',
    laboratory: 'My test lab'
  )

  Users::Grower.create!(
    role: :grower,
    email: 'dev+grower@progeser.com',
    password: 'password',
    password_confirmation: 'password',
    first_name: 'Grower',
    last_name: 'ProGeSer'
  )

  discarded_user = Users::Requester.create!(
    role: :requester,
    email: 'discarded_requester@progeser.com',
    password: 'password',
    password_confirmation: 'password',
    first_name: 'Discarded',
    last_name: 'User'
  )
  discarded_user.discard
end
