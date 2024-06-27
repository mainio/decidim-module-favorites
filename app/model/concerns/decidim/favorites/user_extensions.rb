# frozen_string_literal: true

module Decidim
  module Favorites
    module UserExtensions
      extend ActiveSupport::Concern

      def favoriting?(favoritable)
        Decidim::Favorites::Favorite.where(user: self, favoritable:).any?
      end
    end
  end
end
