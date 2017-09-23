# frozen_string_literal: true

module AuthorizationHelpers
  def with_authorization_handlers(handlers)
    previous_handlers = Decidim.authorization_handlers
    Decidim.authorization_handlers = handlers

    yield
  ensure
    Decidim.authorization_handlers = previous_handlers
  end
end

RSpec.configure do |config|
  config.include AuthorizationHelpers, with_authorizations: true
end
