# frozen_string_literal: true

require "spec_helper"
require "decidim/api/test/type_context"

module Decidim
  module Core
    # We are really testing: lib/decidim/favorites/api/favorites_interface.rb
    describe ComponentType do
      Decidim::Component.include Decidim::Favorites::Favoritable
      Decidim::Core::ComponentType.implements Decidim::Favorites::Api::FavoritesInterface
      include_context "with a graphql class type"

      let!(:favorite) { create(:favorite, favoritable: model, user: user) }
      let(:model) { create(:dummy_component, organization: user.organization) }
      let(:user) { create(:user, :confirmed) }

      describe "favoriteCount" do
        let(:query) { "{ favoriteCount }" }

        it "returns the component's favoriteCount" do
          expect(response["favoriteCount"]).to eq(1)
        end
      end
    end
  end
end
