# frozen_string_literal: true

require "spec_helper"

describe Decidim::Favorites::FavoritesCountCell, type: :cell do
  controller Decidim::Favorites::FavoritesController
  let(:organization) { create(:organization) }

  context "when static page is favoritable" do
    let(:static_page) { create(:static_page, organization:) }

    it "renders the count" do
      html = cell("decidim/favorites/favorites_count", static_page, hide_text: true).call
      expect(html).to have_css(".show-for-sr", text: "No one has yet added this to their favourites")
    end
  end
end
