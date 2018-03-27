# frozen_string_literal: true

module Geoserver
  module Publish
    def create_coverage_store(workspace_name:, coverage_store_name:, url:, connection: nil)
      return if CoverageStore.new(connection).find(workspace_name: workspace_name, coverage_store_name: coverage_store_name)
      CoverageStore.new(connection).create(workspace_name: workspace_name, coverage_store_name: coverage_store_name, url: url)
    end

    def create_coverage(workspace_name:, coverage_store_name:, coverage_name:, title:, connection: nil)
      return if Coverage.new(connection).find(workspace_name: workspace_name, coverage_store_name: coverage_store_name, coverage_name: coverage_name)
      Coverage.new(connection).create(workspace_name: workspace_name, coverage_store_name: coverage_store_name, coverage_name: coverage_name, title: title)
    end

    def create_data_store(workspace_name:, data_store_name:, url:, connection: nil)
      return if DataStore.new(connection).find(workspace_name: workspace_name, data_store_name: data_store_name)
      DataStore.new(connection).create(workspace_name: workspace_name, data_store_name: data_store_name, url: url)
    end

    def create_feature_type(workspace_name:, data_store_name:, feature_type_name:, title:, connection: nil)
      return if FeatureType.new(connection).find(workspace_name: workspace_name, data_store_name: data_store_name, feature_type_name: feature_type_name)
      FeatureType.new(connection).create(workspace_name: workspace_name, data_store_name: data_store_name, feature_type_name: feature_type_name, title: title)
    end

    def create_workspace(workspace_name:, connection: nil)
      return if Workspace.new(connection).find(workspace_name: workspace_name)
      Workspace.new(connection).create(workspace_name: workspace_name)
    end

    module_function :create_coverage_store, :create_coverage, :create_data_store, :create_feature_type, :create_workspace
  end
end
