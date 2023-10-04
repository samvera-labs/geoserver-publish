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

      def create(workspace_name:, coverage_store_name:, url:, type: "GeoTIFF", additional_payload: nil)
        path = coverage_store_url(workspace_name: workspace_name, coverage_store_name: nil)
        payload = payload_new(workspace_name: workspace_name, coverage_store_name: coverage_store_name, url: url, type: type, payload: additional_payload)
        connection.post(path: path, payload: payload)
      end

      def update(workspace_name:, coverage_store_name:, url:, type: "GeoTIFF", additional_payload: nil)
        path = coverage_store_url(workspace_name: workspace_name, coverage_store_name: coverage_store_name)
        payload = payload_new(workspace_name: workspace_name, coverage_store_name: coverage_store_name, url: url, type: type, payload: additional_payload)
        connection.put(path: path, payload: payload, content_type: "application/json")
      end

      ##
      # Upload raster data files to a new coverage store
      # # @param workspace_name [String]
      # # @param coverage_store_name [String]
      # # @param format [String] One of:
      #     geotiff == GeoTIFF
      #     worldimage == Georeferenced image (JPEG, PNG, TIFF)
      #     imagemosaic == Image mosaic
      #     See: https://docs.geoserver.org/stable/en/user/rest/api/coveragestores.html#extension
      # # @param file [String] Depending on value of method:
      #     file == binary stream
      #     url == URL to publicly available raster files (DOESN'T ACTUALLY WORK).
      #     external == absolute path to existing file
      # # @param content_type [String] Content-Type for file upload
      # # @param method [String] Can be one of 'file', 'url', 'external'.
      #     See: https://docs.geoserver.org/latest/en/api/#1.0.0/coveragestores.yaml
      # rubocop:disable Metrics/ParameterLists
      def upload(workspace_name:, coverage_store_name:, format:, file:, method: "file", content_type: "application/zip")
        path = upload_url(
          workspace_name: workspace_name,
          coverage_store_name: coverage_store_name,
          method: method,
          format: format
        )

        connection.put(path: path, payload: file, content_type: content_type)
      end
      # rubocop:enable Metrics/ParameterLists

      private

      def coverage_store_url(workspace_name:, coverage_store_name:)
        last_path_component = coverage_store_name ? "/#{coverage_store_name}" : ""
        "workspaces/#{workspace_name}/coveragestores#{last_path_component}"
      end

      # see: https://docs.geoserver.org/latest/en/api/#1.0.0/coveragestores.yaml
      # /workspaces/{workspace}/coveragestores/{store}/{method}.{format}
      def upload_url(workspace_name:, coverage_store_name:, method:, format:)
        "workspaces/#{workspace_name}/coveragestores/#{coverage_store_name}/#{method}.#{format}?coverageName=#{coverage_store_name}"
      end

      def payload_new(workspace_name:, coverage_store_name:, type:, url:, payload:)
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
          }.merge(payload.to_h)
        }.to_json
      end
    end
  end
end
