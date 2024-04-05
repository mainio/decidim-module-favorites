# frozen_string_literal: true

module Decidim
  module Favorites
    # This concern contains the logic related to favoritable resources.
    module Favoritable
      extend ActiveSupport::Concern

      included do
        has_many(
          :favorites,
          as: :favoritable,
          foreign_key: "decidim_favoritable_id",
          foreign_type: "decidim_favoritable_type",
          class_name: "Decidim::Favorites::Favorite",
          counter_cache: :favorites_count
        )
        has_many :favoriting, through: :favorites, source: :user

        scope :user_favorites, lambda { |user|
          includes(:favorites).where(
            decidim_favorites_favorites: { decidim_user_id: user.id }
          ).order(favorites_order)
        }
      end

      class_methods do
        def favorites_order
          "decidim_favorites_favorites.created_at DESC, #{table_name}.created_at DESC"
        end
      end
    end
  end
end
