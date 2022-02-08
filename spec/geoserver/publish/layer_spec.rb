# frozen_string_literal: true
require "spec_helper"

RSpec.describe Geoserver::Publish::Layer do
  subject(:layer_object) { described_class.new }
  let(:base_url) { "http://localhost:8080/geoserver/rest" }
  let(:path) { "#{base_url}/layers/#{layer_name}" }
  let(:layer_name) { "foo" }

  describe "#delete" do
    context "with a 200 OK response" do
      let(:response) { "" }

      before do
        stub_geoserver_delete(path: path, response: response, status: 200)
      end

      it "makes a delete request and returns true" do
        expect(layer_object.delete(layer_name: layer_name)).to be true
      end
    end

    context "with a 404 not found response" do
      let(:response) { "not found" }

      before do
        stub_geoserver_delete(path: path, response: response, status: 404)
      end

      it "makes a delete request to geoserver and raises an exception" do
        expect { layer_object.delete(layer_name: layer_name) }.to raise_error(Geoserver::Publish::Error)
      end
    end
  end

  describe "#update" do
    let(:payload) { Fixtures.file_fixture("payload/layer.json").read.strip }

    context "with a 200 OK response" do
      it "makes a put request and returns true" do
        stub_geoserver_put(payload: payload, path: path, status: 200, content_type: "application/json")

        expect(layer_object.update(layer_name: layer_name, additional_payload: JSON.parse(payload))).to be true
      end
    end

    context "with a 404 not found response" do
      let(:response) { "not found" }

      it "makes an update request to geoserver and raises an exception" do
        stub_geoserver_put(payload: payload, path: path, status: 404, content_type: "application/json")

        expect { layer_object.update(layer_name: layer_name, additional_payload: JSON.parse(payload)) }.to raise_error(Geoserver::Publish::Error)
      end
    end
  end

  describe "#find" do
    context "when a layer is found" do
      let(:response) { Fixtures.file_fixture("payload/layer.json").read }

      before do
        stub_geoserver_get(path: path, response: response, status: 200)
      end

      it "returns a the properties as a hash" do
        expect(layer_object.find(layer_name: layer_name)).to eq(JSON.parse(response))
      end
    end

    context "when a layer is not found" do
      let(:response) { "not found" }

      before do
        stub_geoserver_get(path: path, response: response, status: 404)
      end

      it "returns nil" do
        expect(layer_object.find(layer_name: layer_name)).to be_nil
      end
    end
  end
end
