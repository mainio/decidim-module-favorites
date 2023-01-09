# frozen_string_literal: true

require "spec_helper"

module Decidim::Favorites
  describe DestroyFavorite do
    subject { described_class.new(form, user) }

    let(:user) { create(:user, :confirmed) }
    let(:form) { double(invalid?: invalid, favorite: favorite) }
    let(:invalid) { false }
    let(:dummy_component) { create(:dummy_component, name: "Dummy name") }
    let!(:favorite) { create(:favorite, favoritable: dummy_component, user: user) }

    context "when everything is ok" do
      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "deletes favorite" do
        expect do
          subject.call
        end.to change(Decidim::Favorites::Favorite, :count).by(-1)
      end
    end
  end
end
