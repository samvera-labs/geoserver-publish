# frozen_string_literal: true
module Geoserver
  module Publish
    class Workspace
      attr_reader :connection

      def initialize(conn = nil)
        @connection = conn || Geoserver::Publish::Connection.new
      end

      def delete(workspace_name:)
        path = workspace_url(workspace_name: workspace_name)
        connection.delete(path: path)
      end

      def find(workspace_name:)
        path = workspace_url(workspace_name: workspace_name)
        out = connection.get(path: path)
        JSON.parse(out) if out
      end

      def create(workspace_name:)
        path = workspace_url(workspace_name: nil)
        connection.post(path: path, payload: payload_new(workspace_name: workspace_name))
      end

      private

        def payload_new(workspace_name:)
          {
            workspace: {
              name: workspace_name
            }
          }.to_json
        end

        def workspace_url(workspace_name:)
          last_path_component = workspace_name ? "/#{workspace_name}" : ""
          "workspaces#{last_path_component}"
        end
    end
  end
end
