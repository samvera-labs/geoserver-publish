# frozen_string_literal: true
module GeoServerSync
  class Coverage
    attr_reader :connection

    def initialize(conn = nil)
      @connection = conn || GeoServerSync::Connection.new
    end

    def delete(workspace_name:, coverage_store_name:, coverage_name:)
      path = coverage_store_url(workspace_name: workspace_name, coverage_store_name: coverage_store_name, coverage_name: coverage_name)
      connection.delete(path: path)
    end

    def find(workspace_name:, coverage_store_name:, coverage_name:)
      path = coverage_store_url(workspace_name: workspace_name, coverage_store_name: coverage_store_name, coverage_name: coverage_name)
      out = connection.get(path: path)
      JSON.parse(out)
    end

    def create(workspace_name:, coverage_store_name:, coverage_name:, title:)
      path = coverage_store_url(workspace_name: workspace_name, coverage_store_name: coverage_store_name, coverage_name: nil)
      payload = payload_new(coverage_name: coverage_name, title: title)
      connection.post(path: path, payload: payload)
    end

    private

      def coverage_store_url(workspace_name:, coverage_store_name:, coverage_name:)
        final_slash = coverage_name ? "/" : ""
        "workspaces/#{workspace_name}/coveragestores/#{coverage_store_name}/coverages#{final_slash}#{coverage_name}"
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
