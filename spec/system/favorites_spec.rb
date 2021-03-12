# frozen_string_literal: true

require "spec_helper"
require "cell"

describe "User favorites", type: :system do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :confirmed, organization: organization) }
  # let(:static_page) { create(:static_page, organization: organization) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  describe "#index" do
    it "shows dummy message" do
      visit "/favorites"
      expect(page).to have_content("You can add personal favorites from the add to favorites button.")
    end
  end

  context "when user has favorites" do
    let(:dummy_component) { create(:dummy_component, organization: organization, name: "Dummy name") }
    let!(:favorite) { create(:favorite, favoritable: dummy_component, user: user) }

    before do
      allow(Decidim::Component).to receive(:user_favorites).and_return([favorite])
    end

    it "shows favorite" do
      visit "/favorites"
      expect(page.find(".page-item")).to have_content("Component")
      expect(page).to have_content("Here you can see all favourites")
    end
  end

  # context "when static pages are favoritable" do
  #   before do
  #     static_page.show_in_footer = true
  #     static_page.save!
  #   end

  #   it "shows it in static pages" do
  #     visit "/"
  #     click_link static_page.title["en"]
  #     click_button(".favorite-button")
  #     expect(Decidim::Favorites::Favorite.count).to eq(1)
  #   end
  # end
end
