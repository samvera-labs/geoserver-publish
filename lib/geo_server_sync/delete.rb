# frozen_string_literal: true

module GeoServerSync
  def delete_geotiff(workspace_name:, id:)
    CoverageStore.new.delete(workspace_name: workspace_name, coverage_store_name: id)
  end

  def delete_shapefile(workspace_name:, id:)
    DataStore.new.delete(workspace_name: workspace_name, data_store_name: id)
  end

  module_function :delete_geotiff, :delete_shapefile
end
