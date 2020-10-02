# frozen_string_literal: true

module Decidim
  module Favorites
    # This concern contains the logic related to favoritable resources.
    module Favoritable
      extend ActiveSupport::Concern

      included do
        has_many :favorites, as: :favoritable, foreign_key: "decidim_favoritable_id", foreign_type: "decidim_favoritable_type", class_name: "Decidim::Favorites::Favorite"
        has_many :favoriting, through: :favorites, source: :user
      end

      class_methods do
        def user_favorites(user)
          includes(:favorites).where(
            decidim_favorites_favorites: { decidim_user_id: user.id }
          ).order(favorites_order)
        end

        def favorites_order
          "decidim_favorites_favorites.created_at DESC, #{table_name}.created_at DESC"
        end
      end
    end
  end
end
