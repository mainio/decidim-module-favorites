# frozen_string_literal: true

module Decidim
  module Favorites
    class Favorite < ApplicationRecord
      include Decidim::DownloadYourData

      belongs_to :favoritable, foreign_key: "decidim_favoritable_id", foreign_type: "decidim_favoritable_type", polymorphic: true
      belongs_to :user, foreign_key: "decidim_user_id", class_name: "Decidim::User"

      validates :user, uniqueness: { scope: [:favoritable] }

      def self.user_collection(user)
        where(decidim_user_id: user.id)
      end

      def self.user_types(user)
        user_collection(user).order(created_at: :desc).pluck(:decidim_favoritable_type).uniq
      end

      def self.export_serializer
        Decidim::Favorites::DataPortabilitySerializers::DataPortabilityFavoriteSerializer
      end
    end
  end
end
