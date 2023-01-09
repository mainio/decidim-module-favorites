# frozen_string_literal: true

require "spec_helper"

module Decidim::Favorites
  describe AddFavorite do
    subject { described_class.new(form, user) }

    let(:user) { create(:user, :confirmed) }
    let(:form) { double(invalid?: invalid, favoritable: dummy_component) }
    let(:invalid) { false }
    let(:dummy_component) { create(:dummy_component, name: "Dummy name") }

    context "when everything is ok" do
      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "creates favorite" do
        expect do
          subject.call
        end.to change(Decidim::Favorites::Favorite, :count).by(1)
      end
    end
  end
end
