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
    require "geoserver/publish/version"
    require "geoserver/publish/workspace"

    def self.delete_geotiff(workspace_name:, id:)
      CoverageStore.new.delete(workspace_name: workspace_name, coverage_store_name: id)
    end

    def self.delete_shapefile(workspace_name:, id:)
      DataStore.new.delete(workspace_name: workspace_name, data_store_name: id)
    end

    def self.geotiff(workspace_name:, file_path:, id:, title: nil)
      create_workspace(workspace_name: workspace_name)
      create_coverage_store(workspace_name: workspace_name, coverage_store_name: id, url: file_path)
      create_coverage(workspace_name: workspace_name, coverage_store_name: id, coverage_name: id, title: title)
    end

    def self.shapefile(workspace_name:, file_path:, id:, title: nil)
      create_workspace(workspace_name: workspace_name)
      create_data_store(workspace_name: workspace_name, data_store_name: id, url: file_path)
      create_feature_type(workspace_name: workspace_name, data_store_name: id, feature_type_name: id, title: title)
    end

    class Error < StandardError
    end
  end
end
