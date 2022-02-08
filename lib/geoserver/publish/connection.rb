# frozen_string_literal: true
module Geoserver
  module Publish
    class Connection
      attr_reader :config

      def initialize(config = nil)
        @config = config || Geoserver::Publish.config["geoserver"]
      end

      def delete(path:)
        response = faraday_connection.delete do |req|
          req.url path
          req.params["recurse"] = "true"
        end
        return true if response.status == 200
        raise Geoserver::Publish::Error, response.reason_phrase
      end

      def get(path:)
        response = faraday_connection.get do |req|
          req.url path
          req.headers["Accept"] = "application/json"
        end
        response.body if response.status == 200
      end

      def post(path:, payload:, content_type: "application/json")
        response = faraday_connection.post do |req|
          req.url path
          req.headers["Content-Type"] = content_type
          req.body = payload
        end
        return true if response.status == 201 || response.status == 401 || response.status == 200
        raise Geoserver::Publish::Error, response.reason_phrase
      end

      def put(path:, payload:, content_type:)
        response = faraday_connection.put do |req|
          req.url path
          req.headers["Content-Type"] = content_type
          req.body = payload
        end
        return true if response.status == 201 || response.status == 200

        raise Geoserver::Publish::Error, response.reason_phrase
      end

      private

      def faraday_connection
        Faraday.new(url: config["url"]) do |conn|
          conn.adapter Faraday.default_adapter
          conn.request(:authorization, :basic, config["user"], config["password"]) if config["user"]
        end
      end
    end
  end
end
