# frozen_string_literal: true

module Decidim
  module Favorites
    # This cell renders the favoriting count for the given resource. This can be
    # used e.g. in the resource cards and it will be automatically updated when
    # the favorite is added or removed by the current user.
    class FavoritingCountCell < Decidim::ViewModel
      include LayoutHelper

      def favoriting_count
        if model.respond_to?(:favoriting_count)
          model.favoriting_count
        else
          model.favoriting.count
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
