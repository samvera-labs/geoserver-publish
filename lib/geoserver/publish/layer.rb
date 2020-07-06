# frozen_string_literal: true
module Geoserver
  module Publish
    class Layer
      attr_reader :connection

      def initialize(conn = nil)
        @connection = conn || Geoserver::Publish::Connection.new
      end

      def delete(layer_name:, workspace_name: nil)
        path = layer_url(layer_name: layer_name, workspace_name: nil)
        connection.delete(path: path)
      end

      def find(layer_name:, workspace_name: nil)
        path = layer_url(layer_name: layer_name, workspace_name: workspace_name)
        out = connection.get(path: path)
        JSON.parse(out) if out
      end

      def update(layer_name:, workspace_name: nil, additional_payload: nil)
        path = layer_url(layer_name: layer_name, workspace_name: workspace_name)
        payload = additional_payload.to_h.to_json
        connection.put(path: path, payload: payload, content_type: "application/json")
      end

      private

        def layer_url(layer_name:, workspace_name: nil)
          path = []
          path.push("workspaces", workspace_name) if workspace_name
          path.push "layers"
          path.push layer_name if layer_name
          path.join("/")
        end
    end
  end
end
