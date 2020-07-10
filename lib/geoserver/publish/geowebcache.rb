# frozen_string_literal: true

module Geoserver
  module Publish
    class Geowebcache
      attr_reader :connection

      def initialize(conn = nil)
        @connection = conn || Geoserver::Publish::Connection.new
      end

      ##
      # This will masstruncate all caches for a given layer. Note: that this
      # implementation differs from the GWC Rest documentation which seems to be
      # wrong. See: https://github.com/GeoWebCache/geowebcache/issues/785
      def masstruncate(layer_name:, request_type: "truncateLayer")
        payload = "<#{request_type}><layerName>#{layer_name}</layerName></#{request_type}>"
        connection.post(
          path: "masstruncate",
          payload: payload,
          content_type: "text/xml"
        )
      end
    end
  end
end
