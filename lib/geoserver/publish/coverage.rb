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

      def create(workspace_name:, coverage_store_name:, coverage_name:, title:, additional_payload: nil)
        path = coverage_url(workspace_name: workspace_name, coverage_store_name: coverage_store_name, coverage_name: nil)
        payload = payload_new(coverage_name: coverage_name, title: title, payload: additional_payload)
        connection.post(path: path, payload: payload)
      end

      def update(workspace_name:, coverage_store_name:, coverage_name:, title:, additional_payload: nil)
        path = coverage_url(workspace_name: workspace_name, coverage_store_name: coverage_store_name, coverage_name: coverage_name)
        payload = payload_new(coverage_name: coverage_name, title: title, payload: additional_payload)
        connection.put(path: path, payload: payload, content_type: "application/json")
      end

      private

      def coverage_url(workspace_name:, coverage_store_name:, coverage_name:)
        last_path_component = coverage_name ? "/#{coverage_name}" : ""
        "workspaces/#{workspace_name}/coveragestores/#{coverage_store_name}/coverages#{last_path_component}"
      end

      def payload_new(coverage_name:, title:, payload: nil)
        {
          coverage: {
            enabled: true,
            name: coverage_name,
            title: title
          }.merge(payload.to_h)
        }.to_json
      end
    end
  end
end
