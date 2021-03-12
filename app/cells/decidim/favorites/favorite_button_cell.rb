# frozen_string_literal: true

module Decidim
  module Favorites
    # This cell renders the button to add the given resource to favorites.
    class FavoriteButtonCell < Decidim::ViewModel
      include LayoutHelper
      include Decidim::SanitizeHelper
      include Decidim::ResourceHelper

      def show
        return if model == current_user

        render
      end

      def example
        render :example
      end

      private

      def button(title, path, method)
        button_to(
          path,
          params: { favorite: { favoritable_gid: model.to_sgid.to_s } },
          class: button_classes,
          data: tooltip_data.merge(disable: true),
          title: show_tooltip? ? title : nil,
          "aria-haspopup" => true,
          method: method,
          remote: true
        ) do
          yield
        end
      end

      def button_params
        {
          hide_text: options[:hide_text],
          disable_tooltip: options[:disable_tooltip],
          button_class: options[:button_class]
        }
      end

      # rubocop:disable Style/OptionalBooleanParameter
      def tooltip_data(force = false)
        return {} if !force && !show_tooltip?

        {
          tooltip: true,
          disable_hover: false,
          keep_on_hover: true,
          click_open: false
        }
      end
      # rubocop:enable Style/OptionalBooleanParameter

      def display_text?
        !options[:hide_text].presence
      end

      def show_tooltip?
        !options[:disable_tooltip].presence
      end

      def favoriting_count
        if model.respond_to?(:favoriting_count)
          model.favoriting_count
        else
          model.favoriting.count
        end
      end

      def button_classes
        extra_classes = ""
        extra_classes += " active" if current_user_favoriting?

        button_class = options[:button_class] || "button clear button--icon"

        "#{button_class} favorite-button #{extra_classes}"
      end

      def icon_options
        { aria_hidden: true }
      end

      def render_screen_reader_title_for(resource)
        content_tag :span, class: "show-for-sr" do
          decidim_html_escape(resource_title(resource))
        end
      end

      def current_user_favoriting?
        return false unless current_user

        current_user.favoriting?(model)
      end

      def decidim_favorites
        Decidim::Favorites::Engine.routes.url_helpers
      end
    end
  end
end
