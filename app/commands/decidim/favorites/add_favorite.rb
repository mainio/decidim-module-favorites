# frozen_string_literal: true

module Decidim
  module Favorites
    # A command to add a new favorite to the user.
    class AddFavorite < Rectify::Command
      # Public: Initializes the command.
      #
      # form - The favoritable form.
      # user - The user to add the favorite for.
      def initialize(form, user)
        @form = form
        @user = user
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the handler wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if form.invalid?

        favorite = Decidim::Favorites::Favorite.create!(
          favoritable: form.favoritable,
          user: user
        )

        broadcast(:ok, favorite)
      end

      private

      attr_reader :form, :user
    end
  end
end
