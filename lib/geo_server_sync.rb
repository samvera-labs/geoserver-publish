# frozen_string_literal: true
require "byebug"
require "erb"
require "faraday"
require "json"
require "yaml"

module GeoServerSync
  require "geo_server_sync/config"
  require "geo_server_sync/connection"
  require "geo_server_sync/coverage"
  require "geo_server_sync/coverage_store"
  require "geo_server_sync/data_store"
  require "geo_server_sync/version"
  require "geo_server_sync/workspace"

  def publish_geotiff_layer(workspace_name:, file_path:, id:, title: nil)
    Workspace.new.create(workspace_name: workspace_name)
    CoverageStore.new.create(workspace_name: workspace_name, coverage_store_name: id, url: file_path)
    Coverage.new.create(workspace_name: workspace_name, coverage_store_name: id, coverage_name: id, title: title)
  end

  module_function :publish_geotiff_layer

  class Error < StandardError
  end
end
