# frozen_string_literal: true

module Decidim
  module Favorites
    # A form object to be used when users want to add a resource in favorites.
    class FavoriteForm < Decidim::Form
      mimic :favorite

      attribute :favoritable_gid, String

      validates :favoritable_gid, :favoritable, presence: true
      validates :favoritable, exclusion: { in: ->(form) { [form.current_user] } }

      def favoritable
        @favoritable ||= GlobalID::Locator.locate_signed favoritable_gid
      end

      def favorite
        @favorite ||= Decidim::Favorites::Favorite.find_by(
          user: current_user,
          favoritable: favoritable
        )
      end
    end
  end
end
