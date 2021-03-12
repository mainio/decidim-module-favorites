# frozen_string_literal: true

require "spec_helper"

module Decidim::Favorites
  describe FavoriteButtonCell, type: :cell do
    controller Decidim::Favorites::FavoritesController

    let(:organization) { create(:organization) }
    let(:static_page) { create(:static_page, organization: organization) }

    it "has screen reader label" do
      html = cell("decidim/favorites/favorite_button", static_page, hide_text: true).call
      expect(html).to have_css(".show-for-sr", text: "Add to favourites")
    end
  end
end
