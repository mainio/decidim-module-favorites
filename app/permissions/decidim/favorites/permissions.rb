# frozen_string_literal: true

module Decidim
  module Favorites
    class Permissions < Decidim::DefaultPermissions
      def permissions
        return permission_action unless permission_action.scope == :public
        return permission_action unless user

        favorite_action?

        permission_action
      end

      private

      def favorite_action?
        return unless permission_action.subject == :favorite
        return allow! if permission_action.action == :create

        favorite = context.fetch(:favorite, nil)
        toggle_allow(favorite&.user == user)
      end
    end
  end
end
