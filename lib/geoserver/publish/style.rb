# frozen_string_literal: true
module Geoserver
  module Publish
    ##
    # Class for interacting with GeoServer Styles API.
    # **NOTE** This assumes only the top level styles path /styles and does not
    # work with workspace and layer based styles.
    class Style
      attr_reader :connection

      def initialize(conn = nil)
        @connection = conn || Geoserver::Publish::Connection.new
      end

      def delete(style_name:)
        path = style_url(style_name: style_name)
        connection.delete(path: path)
      end

      def find(style_name:)
        path = style_url(style_name: style_name)
        out = connection.get(path: path)
        JSON.parse(out) if out
      end

      ##
      # Create will update the GeoServer catalog, but not provide the style
      def create(style_name:, filename:, additional_payload: nil)
        path = style_url(style_name: nil)
        payload = payload_new(style_name: style_name, filename: filename, payload: additional_payload)
        connection.post(path: path, payload: payload)
      end

      ##
      # Update requires and uses the payload to upload an SLD
      def update(style_name:, filename:, payload:)
        path = style_url(style_name: style_name)
        connection.put(path: path, payload: payload, content_type: "application/vnd.ogc.sld+xml")
      end

      private

      def style_url(style_name:)
        last_path_component = style_name ? "/#{style_name}" : ""
        "styles#{last_path_component}"
      end

      def payload_new(style_name:, filename:, payload: nil)
        {
          style: {
            name: style_name,
            filename: filename
          }.merge(payload.to_h)
        }.to_json
      end
    end
  end
end
