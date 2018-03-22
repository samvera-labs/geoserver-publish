# frozen_string_literal: true
module GeoserverStubbing
  def stub_geoserver_post(path:, payload:, status:)
    stub_request(:post, path)
      .with(body: payload, headers: { "Content-Type" => "application/json" })
      .to_return(status: status, body: "response", headers: {})
  end

  def stub_geoserver_get(path:, response:, status:)
    stub_request(:get, path)
      .with(headers: { "Accept" => "application/json" })
      .to_return(status: status, body: response, headers: {})
  end

  def stub_geoserver_delete(path:, response:, status:)
    stub_request(:delete, path)
      .with(query: { "recurse" => "true" })
      .to_return(status: status, body: response, headers: {})
  end
end

RSpec.configure do |config|
  config.include GeoserverStubbing
end
