# frozen_string_literal: true
require "spec_helper"

RSpec.describe Geoserver::Publish::Geowebcache do
  subject(:layer_object) { described_class.new }
  let(:base_url) { "http://localhost:8080/geoserver/rest" }
  let(:layer_name) { "foo" }


  describe "#masstruncate" do
    let(:path) { "#{base_url}/masstruncate" }
    context "with a 200 OK response" do
      let(:response) { "" }
      let(:payload) { "<truncateLayer><layerName>foo</layerName></truncateLayer>" }

      before do
        stub_geoserver_post(path: path, status: 200, payload: payload, content_type: "text/xml")
      end

      it "makes a delete request and returns true" do
        expect(layer_object.masstruncate(layer_name: layer_name)).to be true
      end
    end
  end
end
