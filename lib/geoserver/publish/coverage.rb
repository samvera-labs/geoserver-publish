# frozen_string_literal: true
module Geoserver
  module Publish
    class Coverage
      attr_reader :connection

      def initialize(conn = nil)
        @connection = conn || Geoserver::Publish::Connection.new
      end

      def delete(workspace_name:, coverage_store_name:, coverage_name:)
        path = coverage_url(workspace_name: workspace_name, coverage_store_name: coverage_store_name, coverage_name: coverage_name)
        connection.delete(path: path)
      end

      def find(workspace_name:, coverage_store_name:, coverage_name:)
        path = coverage_url(workspace_name: workspace_name, coverage_store_name: coverage_store_name, coverage_name: coverage_name)
        out = connection.get(path: path)
        JSON.parse(out) if out
      end

      def create(workspace_name:, coverage_store_name:, coverage_name:, title:)
        path = coverage_url(workspace_name: workspace_name, coverage_store_name: coverage_store_name, coverage_name: nil)
        payload = payload_new(coverage_name: coverage_name, title: title)
        connection.post(path: path, payload: payload)
      end

      private

        def coverage_url(workspace_name:, coverage_store_name:, coverage_name:)
          last_path_component = coverage_name ? "/#{coverage_name}" : ""
          "workspaces/#{workspace_name}/coveragestores/#{coverage_store_name}/coverages#{last_path_component}"
        end

        def payload_new(coverage_name:, title:)
          {
            coverage: {
              enabled: true,
              name: coverage_name,
              title: title
            }
          }.to_json
        end
    end
  end
end
