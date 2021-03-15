# frozen_string_literal: true

require "spec_helper"
# require "cell"
# require "action_view/railtie"

describe "User favorites", type: :system do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :confirmed, organization: organization) }
  let!(:dummy_resource) { create(:dummy_resource) }

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

  context "when favorite button is rendered" do
    subject { described_class }

    let(:html_body) do
      Decidim::ViewModel.cell("decidim/favorites/favorite_button", dummy_resource, context: { current_user: user }).call.to_s +
        Decidim::ViewModel.cell("decidim/favorites/favoriting_count", dummy_resource).call.to_s
    end
    let(:html_head) { "" }
    let(:html_document) do
      document_inner = html_body
      head_extra = html_head
      template.instance_eval do
        <<~HTML.strip
          <!doctype html>
          <html lang="en">
          <head>
            <title>Favorite Button Test</title>
            #{stylesheet_link_tag "application"}
            #{javascript_include_tag "application"}
            #{head_extra}
          </head>
          <body>
            #{document_inner}
          </body>
          </html>
        HTML
      end
    end
    let(:template_class) do
      Class.new(ActionView::Base) do
        def protect_against_forgery?
          false
        end
      end
    end
    let(:template) { template_class.new }
    let(:favorite) { create(:favorite, favoritable: dummy_component, user: user) }

    before do
      final_html = html_document
      Rails.application.routes.draw do
        mount Decidim::Favorites::Engine => "/"
        get "test_favorite_cell", to: ->(_) { [200, {}, [final_html]] }
      end
    end

    it "creates favorite" do
      visit "/test_favorite_cell"
      expect_no_js_errors

      click_button
      expect(page).to have_content("One person has added this to their favourites")
      expect(Decidim::Favorites::Favorite.count).to eq(1)
    end

    # it "destroys favorite" do
    #   favorite
    #   expect_no_js_errors

    #   click_button
    #   expect(page).to have_content("No one has yet added this to their favourites")
    # end
  end
end

Decidim::Favorites::FavoriteButtonCell.class_eval do
  define_method :protect_against_forgery? do
    false
  end
end

module Decidim
  module DummyResources
    class DummyResource
      include Decidim::Favorites::Favoritable
    end
  end
end
