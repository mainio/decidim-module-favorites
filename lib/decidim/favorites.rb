# frozen_string_literal: true

require_relative "favorites/version"
require_relative "favorites/engine"

module Decidim
  module Favorites
    autoload :Favoritable, "decidim/favorites/favoritable"
  end
end
