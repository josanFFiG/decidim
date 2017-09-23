# frozen_string_literal: true

require "decidim/dev/dummy_authorization_handler"

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

  config.before(:suite) do
    Decidim.config.authorization_handlers = [Decidim::DummyAuthorizationHandler]
  end
end
