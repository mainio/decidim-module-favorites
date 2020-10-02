# frozen_string_literal: true

require_relative "favorites/version"
require_relative "favorites/engine"
require_relative "favorites/api"

module Decidim
  module Favorites
    autoload :Favoritable, "decidim/favorites/favoritable"
  end
end
