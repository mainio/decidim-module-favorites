# frozen_string_literal: true

module Decidim
  module Favorites
    # This class serializes a Favorite so can be exported to CSV
    module DataPortabilitySerializers
      class DataPortabilityFavoriteSerializer < Decidim::Exporters::Serializer
        include Decidim::ResourceHelper

        # Public: Exports a hash with the serialized data for favorite.
        def serialize
          {
            id: resource.id,
            favoritable: {
              id: resource.decidim_favoritable_id,
              type: resource.decidim_favoritable_type
            },
            created_at: resource.created_at,
            updated_at: resource.updated_at
          }
        end
      end
    end
  end
end
