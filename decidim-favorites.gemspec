# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "decidim/favorites/version"

Gem::Specification.new do |spec|
  spec.name = "decidim-favorites"
  spec.version = Decidim::Favorites::VERSION
  spec.authors = ["Antti Hukkanen"]
  spec.email = ["antti.hukkanen@mainiotech.fi"]

  spec.summary = "Adds possibility to add favorites to user's personal lists."
  spec.description = "Developers can define the favorites functionality to any existing objects and the user will see them in their profiles."
  spec.homepage = "https://github.com/mainio/decidim-module-favorites"
  spec.license = "AGPL-3.0"

  spec.files = Dir[
    "{app,config,lib}/**/*",
    "LICENSE-AGPLv3.txt",
    "Rakefile",
    "README.md"
  ]

  spec.require_paths = ["lib"]

  spec.add_dependency "decidim-core", Decidim::Favorites::DECIDIM_VERSION

  spec.add_development_dependency "decidim-dev", Decidim::Favorites::DECIDIM_VERSION
end
