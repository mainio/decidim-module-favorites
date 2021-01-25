# frozen_string_literal: true

module Decidim
  module Favorites
    class FavoritesController < Decidim::ApplicationController
      include Decidim::FormFactory

      helper Decidim::CardHelper
      helper_method :types, :button_options

      before_action :authenticate_user!
      before_action :set_types, only: [:index, :show]
      before_action :set_button_options, only: [:create, :destroy]

      skip_before_action :store_current_location

      def index
        redirect_to favorite_path(types.keys.first) if types.any?
      end

      def show
        @selected_type = params[:type]
        @type = types[@selected_type]
        raise ActionController::RoutingError, "Not Found" unless @type

        @resources = @type[:klass].user_favorites(current_user)
      end

      def create
        enforce_permission_to :create, :favorite

        @form = form(Decidim::Favorites::FavoriteForm).from_params(params)
        @favoritable = @form.favoritable

        Decidim::Favorites::AddFavorite.call(@form, current_user) do
          on(:ok) do
            render :update_button
          end

          on(:invalid) do
            render json: { error: I18n.t("create.error", scope: "decidim.favorites") }, status: :unprocessable_entity
          end
        end
      end

      def destroy
        @form = form(Decidim::Favorites::FavoriteForm).from_params(params)
        enforce_permission_to :delete, :favorite, favorite: @form.favorite

        @favoritable = @form.favoritable

        Decidim::Favorites::DestroyFavorite.call(@form, current_user) do
          on(:ok) do
            render :update_button
          end

          on(:invalid) do
            render json: { error: I18n.t("destroy.error", scope: "decidim.favorites") }, status: :unprocessable_entity
          end
        end
      end

      def permission_scope
        :public
      end

      def permission_class_chain
        [
          ::Decidim::Favorites::Permissions,
          ::Decidim::Permissions
        ]
      end

      private

      attr_reader :types, :button_options

      def set_types
        @types = Decidim::Favorites::Favorite.user_types(current_user).map do |type|
          klass = type.constantize

          [
            klass.model_name.singular,
            {
              klass: klass,
              name: klass.model_name.human(count: 2)
            }
          ]
        end.to_h
      end

      def set_button_options
        @button_options = {
          hide_text: params[:hide_text],
          disable_tooltip: params[:disable_tooltip],
          button_class: params[:button_class]
        }
      end

      def favoritable
        @favoritable ||= GlobalID::Locator.locate_signed(
          params[:id] || params[:favoritable_gid]
        )
      end
    end
  end
end
