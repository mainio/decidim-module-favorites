# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Favorites
    describe FavoriteForm do
      subject { form }

      let(:user) { create(:user, :confirmed) }
      let(:dummy_component) { create(:dummy_component, name: "Dummy name", organization: user.organization) }
      let(:params) do
        {
          favoritable_gid: dummy_component.to_sgid.to_s
        }
      end

      let(:form) do
        described_class.from_params(params).with_context(
          current_user: user
        )
      end

      context "when everything is ok" do
        it do
          expect(subject).to be_valid
        end
      end

      describe "#favorite" do
        let!(:favorite) { create(:favorite, favoritable: dummy_component, user: user) }

        it "finds favorite" do
          expect(subject.favorite).to eq(favorite)
        end
      end
    end
  end
end
