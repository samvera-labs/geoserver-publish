# frozen_string_literal: true
module Geoserver
  module Publish
    class CoverageStore
      attr_reader :connection

      def initialize(conn = nil)
        @connection = conn || Geoserver::Publish::Connection.new
      end

      def delete(workspace_name:, coverage_store_name:)
        path = coverage_store_url(workspace_name: workspace_name, coverage_store_name: coverage_store_name)
        connection.delete(path: path)
      end

      def find(workspace_name:, coverage_store_name:)
        path = coverage_store_url(workspace_name: workspace_name, coverage_store_name: coverage_store_name)
        out = connection.get(path: path)
        JSON.parse(out) if out
      end

      def create(workspace_name:, coverage_store_name:, url:, type: "GeoTIFF")
        path = coverage_store_url(workspace_name: workspace_name, coverage_store_name: nil)
        payload = payload_new(workspace_name: workspace_name, coverage_store_name: coverage_store_name, url: url, type: type)
        connection.post(path: path, payload: payload)
      end

      private

        def coverage_store_url(workspace_name:, coverage_store_name:)
          last_path_component = coverage_store_name ? "/#{coverage_store_name}" : ""
          "workspaces/#{workspace_name}/coveragestores#{last_path_component}"
        end

        def payload_new(workspace_name:, coverage_store_name:, type:, url:)
          {
            coverageStore: {
              name: coverage_store_name,
              url: url,
              enabled: true,
              workspace: {
                name: workspace_name
              },
              type: type,
              _default: false
            }
          }.to_json
        end
    end
  end
end
