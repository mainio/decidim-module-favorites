# frozen_string_literal: true

module Decidim
  module Favorites
    module Api
      module FavoritesInterface
        include GraphQL::Schema::Interface

        graphql_name "FavoritesInterface"
        description "This interface is implemented by any object that can be added as a favorite."

        field :favoriteCount, Integer, resolver_method: :favorite_count, null: true do
          description "The total amount of how many time the record has been added to favorites"
        end

        def favorite_count
          object.favorites.count
        end
      end
    end
  end
end
