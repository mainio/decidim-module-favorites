# frozen_string_literal: true

require "spec_helper"

describe Decidim::Favorites::FavoritingCountCell, type: :cell do
  controller Decidim::Favorites::FavoritesController
  let(:organization) { create(:organization) }

  context "when static page is favoritable" do
    Decidim::StaticPage.include Decidim::Favorites::Favoritable
    let(:static_page) { create(:static_page, organization: organization) }

    it "renders the count" do
      html = cell("decidim/favorites/favoriting_count", static_page, hide_text: true).call
      expect(html).to have_css(".show-for-sr", text: "No one has yet added this to their favourites")
    end
  end
end
