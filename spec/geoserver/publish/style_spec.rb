# frozen_string_literal: true
require "spec_helper"

RSpec.describe Geoserver::Publish::Style do
  subject(:style_object) { described_class.new }
  let(:base_url) { "http://localhost:8080/geoserver/rest" }
  let(:path) { "#{base_url}/styles/#{style_name}" }
  let(:style_name) { "raster_layer" }
  let(:filename) { "raster_layer.sld" }

  describe "#create" do
    let(:path) { "#{base_url}/styles" }
    let(:payload) { Fixtures.file_fixture("payload/style.json").read.strip }

    context "when a style is created successfully" do
      before do
        stub_geoserver_post(path: path, payload: payload, status: 201)
      end

      it "returns a true" do
        expect(style_object.create(style_name: style_name, filename: filename)).to be true
      end
    end

    context "when a style is not created successfully" do
      before do
        stub_geoserver_post(path: path, payload: payload, status: 500)
      end

      it "raises an error" do
        expect { style_object.create(style_name: style_name, filename: filename) }.to raise_error(Geoserver::Publish::Error)
      end
    end
  end

  describe "#delete" do
    context "with a 200 OK response" do
      let(:response) { "" }

      before do
        stub_geoserver_delete(path: path, response: response, status: 200)
      end

      it "makes a delete request and returns true" do
        expect(style_object.delete(style_name: style_name)).to be true
      end
    end

    context "with a 404 not found response" do
      let(:response) { "not found" }

      before do
        stub_geoserver_delete(path: path, response: response, status: 404)
      end

      it "makes a delete request to geoserver and raises an exception" do
        expect { style_object.delete(style_name: style_name) }.to raise_error(Geoserver::Publish::Error)
      end
    end
  end

  describe "#update" do
    let(:payload) { Fixtures.file_fixture("payload/raster_layer.sld").read }

    context "with a 200 OK response" do
      it "makes a put request and returns true" do
        stub_geoserver_put(payload: payload, path: path, status: 200, content_type: "application/vnd.ogc.sld+xml")

        expect(style_object.update(style_name: style_name, filename: filename, payload: payload)).to be true
      end
    end

    context "with a 404 not found response" do
      let(:response) { "not found" }

      it "makes an update request to geoserver and raises an exception" do
        stub_geoserver_put(payload: payload, path: path, status: 404, content_type: "application/vnd.ogc.sld+xml")

        expect { style_object.update(style_name: style_name, filename: filename, payload: payload) }.to raise_error(Geoserver::Publish::Error)
      end
    end
  end

  describe "#find" do
    context "when a style is found" do
      let(:response) { Fixtures.file_fixture("response/style.json").read }

      before do
        stub_geoserver_get(path: path, response: response, status: 200)
      end

      it "returns a the properties as a hash" do
        expect(style_object.find(style_name: style_name)).to eq(JSON.parse(response))
      end
    end

    context "when a style is not found" do
      let(:response) { "not found" }

      before do
        stub_geoserver_get(path: path, response: response, status: 404)
      end

      it "returns nil" do
        expect(style_object.find(style_name: style_name)).to be_nil
      end
    end
  end
end
