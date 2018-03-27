# frozen_string_literal: true
require "byebug"
require "erb"
require "faraday"
require "json"
require "yaml"

module Geoserver
  module Publish
    require "geoserver/publish/config"
    require "geoserver/publish/connection"
    require "geoserver/publish/coverage"
    require "geoserver/publish/coverage_store"
    require "geoserver/publish/data_store"
    require "geoserver/publish/delete"
    require "geoserver/publish/feature_type"
    require "geoserver/publish/publish"
    require "geoserver/publish/version"
    require "geoserver/publish/workspace"

    class Error < StandardError
    end
  end
end
