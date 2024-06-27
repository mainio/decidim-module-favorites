# frozen_string_literal: true

require "spec_helper"

module Decidim::Favorites::DataPortabilitySerializers
  describe DataPortabilityFavoriteSerializer do
    subject { described_class.new(favorite) }
    let(:favorite) { create(:favorite, favoritable: dummy_component, user:) }
    let(:dummy_component) { create(:dummy_component, name: "Dummy name", organization: user.organization) }
    let(:user) { create(:user, :confirmed) }
    let(:serialized) { subject.serialize }

    describe "#serializer" do
      it "includes the id" do
        expect(serialized).to include(id: favorite.id)
      end

      it "includes favoritable" do
        expect(serialized[:favoritable]).to include(id: dummy_component.id)
        expect(serialized[:favoritable]).to include(type: dummy_component.class.to_s)
      end
    end
  end
end
