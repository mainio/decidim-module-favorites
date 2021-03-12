# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/dev/test/factories"

FactoryBot.define do
  factory :favorite, class: "Decidim::Favorites::Favorite" do
    # user { build(:user, :confirmed, organization: favoritable.organization) }
  end
end
