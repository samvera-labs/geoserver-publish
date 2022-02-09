# frozen_string_literal: true
module Geoserver
  module Publish
    class FeatureType
      attr_reader :connection

      def initialize(conn = nil)
        @connection = conn || Geoserver::Publish::Connection.new
      end

      def delete(workspace_name:, data_store_name:, feature_type_name:)
        path = feature_type_url(workspace_name: workspace_name, data_store_name: data_store_name, feature_type_name: feature_type_name)
        connection.delete(path: path)
      end

      def find(workspace_name:, data_store_name:, feature_type_name:)
        path = feature_type_url(workspace_name: workspace_name, data_store_name: data_store_name, feature_type_name: feature_type_name)
        out = connection.get(path: path)
        JSON.parse(out) if out
      end

      # Feature type name must be the same name as the shapefile without the extenstion.
      # E.g. If the file is `12345.shp`, then feature_type_name = "12345".
      def create(workspace_name:, data_store_name:, feature_type_name:, title:, additional_payload: nil)
        path = feature_type_url(workspace_name: workspace_name, data_store_name: data_store_name, feature_type_name: nil)
        payload = payload_new(feature_type_name: feature_type_name, title: title, payload: additional_payload)
        connection.post(path: path, payload: payload)
      end

      def update(workspace_name:, data_store_name:, feature_type_name:, title:, additional_payload: nil)
        path = feature_type_url(workspace_name: workspace_name, data_store_name: data_store_name, feature_type_name: feature_type_name)
        payload = payload_new(feature_type_name: feature_type_name, title: title, payload: additional_payload)
        connection.put(path: path, payload: payload, content_type: "application/json")
      end

      private

      def feature_type_url(workspace_name:, data_store_name:, feature_type_name:)
        last_path_component = feature_type_name ? "/#{feature_type_name}" : ""
        "workspaces/#{workspace_name}/datastores/#{data_store_name}/featuretypes#{last_path_component}"
      end

      def payload_new(feature_type_name:, title:, payload:)
        {
          featureType: {
            name: feature_type_name,
            title: title,
            enabled: true
          }.merge(payload.to_h)
        }.to_json
      end
    end
  end
end
