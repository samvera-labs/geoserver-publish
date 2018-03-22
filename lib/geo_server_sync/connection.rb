# frozen_string_literal: true
module GeoServerSync
  class Connection
    attr_reader :config

    def initialize(config = nil)
      @config = config || GeoServerSync.config["geoserver"]
    end

    def delete(path:)
      response = faraday_connection.delete do |req|
        req.url path
        req.params["recurse"] = "true"
      end
      return true if response.status == 200
      raise GeoServerSync::Error, response.reason_phrase
    end

    def get(path:)
      response = faraday_connection.get do |req|
        req.url path
        req.headers["Accept"] = "application/json"
      end
      return response.body if response.status == 200
      raise GeoServerSync::Error, response.reason_phrase
    end

    def post(path:, payload:)
      response = faraday_connection.post do |req|
        req.url path
        req.headers["Content-Type"] = "application/json"
        req.body = payload
      end
      return true if response.status == 201 || response.status == 401
      raise GeoServerSync::Error, response.reason_phrase
    end

    private

      def faraday_connection
        Faraday.new(url: config["url"]) do |conn|
          conn.adapter Faraday.default_adapter
          conn.basic_auth(config["user"], config["password"]) if config["user"]
        end
      end
  end
end
