# frozen_string_literal: true
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
    require "geoserver/publish/create"
    require "geoserver/publish/data_store"
    require "geoserver/publish/feature_type"
    require "geoserver/publish/layer"
    require "geoserver/publish/style"
    require "geoserver/publish/version"
    require "geoserver/publish/workspace"

    def self.delete_geotiff(workspace_name:, id:, connection: nil)
      CoverageStore.new(connection).delete(workspace_name: workspace_name, coverage_store_name: id)
    end

    def self.delete_shapefile(workspace_name:, id:, connection: nil)
      DataStore.new(connection).delete(workspace_name: workspace_name, data_store_name: id)
    end

    def self.geotiff(workspace_name:, file_path:, id:, title: nil, connection: nil)
      create_workspace(workspace_name: workspace_name, connection: connection)
      create_coverage_store(workspace_name: workspace_name, coverage_store_name: id, url: file_path, connection: connection)
      create_coverage(workspace_name: workspace_name, coverage_store_name: id, coverage_name: id, title: title, connection: connection)
    end

    def self.shapefile(workspace_name:, file_path:, id:, title: nil, connection: nil)
      create_workspace(workspace_name: workspace_name, connection: connection)
      create_data_store(workspace_name: workspace_name, data_store_name: id, url: file_path, connection: connection)
      create_feature_type(workspace_name: workspace_name, data_store_name: id, feature_type_name: id, title: title, connection: connection)
    end

    def self.root
      Pathname.new(File.expand_path("../../../", __FILE__))
    end

    class Error < StandardError
    end
  end
end
