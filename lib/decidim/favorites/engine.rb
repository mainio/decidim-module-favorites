# frozen_string_literal: true

module Decidim
  module Favorites
    # This is an engine that controls the favorites functionality.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Favorites

      routes do
        resources :favorites, except: [:edit, :update]

        root to: "favorites#index"
      end

      initializer "decidim_favorites.mount_routes", before: :add_routing_paths do
        Decidim::Core::Engine.routes.append do
          mount Decidim::Favorites::Engine => "/"
        end
      end

      initializer "decidim_favorites.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Favorites::Engine.root}/app/cells")
      end

      config.to_prepare do
        Decidim::User.send(:include, Decidim::Favorites::UserExtensions)
      end
    end
  end
end
