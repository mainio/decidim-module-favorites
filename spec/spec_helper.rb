# frozen_string_literal: true

require "decidim/dev"

ENV["ENGINE_ROOT"] = File.dirname(__dir__)

Decidim::Dev.dummy_app_path =
  File.expand_path(File.join(__dir__, "decidim_dummy_app"))

require "decidim/dev/test/base_spec_helper"

# This re-registration is made because of problems with chromedriver v120.
# Selenium methods are undefined without this change.
# See: https://github.com/decidim/decidim/pull/12160
require "#{ENV.fetch("ENGINE_ROOT")}/lib/decidim/favorites/test/rspec_support/capybara"

RSpec.configure do |config|
  # Add the counter cache columns to the records being tested
  config.before(:all) do
    tables = []
    [
      Decidim::Component,
      Decidim::StaticPage,
      Decidim::DummyResources::DummyResource
    ].each do |klass|
      klass.include Decidim::Favorites::Favoritable
      tables << klass.table_name.to_sym
    end

    ActiveRecord::Migration.suppress_messages do
      tables.each do |table|
        ActiveRecord::Migration.add_column table, :favorites_count, :integer, null: false, default: 0, if_not_exists: true
      end
    end
  end
end
