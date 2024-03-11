# frozen_string_literal: true

module Decidim
  module Favorites
    # This cell renders the favorites count for the given resource. This can be
    # used e.g. in the resource cards and it will be automatically updated when
    # the favorite is added or removed by the current user.
    class FavoritesCountCell < Decidim::ViewModel
      include LayoutHelper

      def favorites_count
        if model.respond_to?(:favorites_count)
          model.favorites_count
        else
          model.favorites.count
        end
      end

      def tooltip_data
        {
          tooltip: true,
          disable_hover: false,
          keep_on_hover: true,
          click_open: false
        }
      end
    end
  end
end
