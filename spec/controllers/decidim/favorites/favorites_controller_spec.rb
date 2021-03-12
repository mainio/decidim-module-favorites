# frozen_string_literal: true

require "spec_helper"

describe Decidim::Favorites::FavoritesController, type: :controller do
  routes { Decidim::Favorites::Engine.routes }

  let(:user) { create(:user, :confirmed) }
  let(:dummy_component) { create(:dummy_component, name: "Dummy name", organization: user.organization) }
  let(:params) { { favoritable_gid: dummy_component.to_sgid.to_s } }

  before do
    request.env["decidim.current_organization"] = user.organization
    sign_in user
  end

  describe "POST create" do
    it "creates new favorite" do
      post :create, format: :js, params: params
      expect(Decidim::Favorites::Favorite.count).to eq(1)
    end
  end

  describe "DELETE destroy" do
    let!(:favorite) { create(:favorite, favoritable: dummy_component, user: user) }
    let(:params) { { type: dummy_component.to_sgid.to_s, favorite: { favoritable_gid: dummy_component.to_sgid.to_s } } }

    it "destroys favorite" do
      expect do
        delete :destroy, format: :js, params: params
      end.to change { Decidim::Favorites::Favorite.count }.by(-1)
    end
  end
end
