# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'

    resource '*',
      headers: :any,
      expose: %w[
        Pagination-Current-Page
        Pagination-Per
        Pagination-Total-Pages
        Pagination-Total-Count
      ],
      methods: %i[get post put patch delete options head]
  end
end
