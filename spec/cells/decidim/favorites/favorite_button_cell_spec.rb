# frozen_string_literal: true

require "spec_helper"

describe Decidim::Favorites::FavoriteButtonCell, type: :cell do
  controller Decidim::Favorites::FavoritesController

  let(:dummy_resource) { create(:dummy_resource) }

  it "has screen reader label" do
    html = cell("decidim/favorites/favorite_button", dummy_resource, hide_text: true).call
    expect(html).to have_css(".show-for-sr", text: "Add to favourites")
  end
end
