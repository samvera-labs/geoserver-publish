# frozen_string_literal: true
require "spec_helper"

RSpec.describe GeoServerSync::CoverageStore do
  subject(:coveragestore_object) { described_class.new }

  let(:base_url) { "http://localhost:8080/geoserver/rest" }
  let(:path) { "#{base_url}/workspaces/#{workspace_name}/coveragestores/#{coverage_store_name}" }
  let(:workspace_name) { "public" }
  let(:coverage_store_name) { "coveragestore" }
  let(:url) { "file:///raster.tif" }

  describe "#create" do
    let(:path) { "#{base_url}/workspaces/public/coveragestores" }
    let(:payload) { '{"coverageStore":{"name":"coveragestore","url":"file:///raster.tif","enabled":true,"workspace":{"name":"public"},"type":"GeoTIFF","_default":false}}' }

    context "when a coveragestore is created successfully" do
      before do
        stub_geoserver_post(path: path, payload: payload, status: 201)
      end

      it "returns a the properties as a hash" do
        expect(coveragestore_object.create(workspace_name: workspace_name, coverage_store_name: coverage_store_name, url: url)).to be true
      end
    end

    context "when a coveragestore is not created successfully" do
      before do
        stub_geoserver_post(path: path, payload: payload, status: 500)
      end

      it "returns a the properties as a hash" do
        expect { coveragestore_object.create(workspace_name: workspace_name, coverage_store_name: coverage_store_name, url: url) }.to raise_error(GeoServerSync::Error)
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
        expect(coveragestore_object.delete(workspace_name: workspace_name, coverage_store_name: coverage_store_name)).to be true
      end
    end

    context "with a 404 not found response" do
      let(:response) { "not found" }

      before do
        stub_geoserver_delete(path: path, response: response, status: 404)
      end

      it "makes a delete request to geoserver and raises an exception" do
        expect { coveragestore_object.delete(workspace_name: workspace_name, coverage_store_name: coverage_store_name) }.to raise_error(GeoServerSync::Error)
      end
    end
  end

  describe "#find" do
    context "when a coveragestore is found" do
      let(:response) { '{"workspace":{"name":"public","isolated":false}}' }

      before do
        stub_geoserver_get(path: path, response: response, status: 200)
      end

      it "returns a the properties as a hash" do
        expect(coveragestore_object.find(workspace_name: workspace_name, coverage_store_name: coverage_store_name)).to eq(JSON.parse(response))
      end
    end

    context "when a coveragestore is not found" do
      let(:response) { "not found" }

      before do
        stub_geoserver_get(path: path, response: response, status: 404)
      end

      it "raises an exception" do
        expect { coveragestore_object.find(workspace_name: workspace_name, coverage_store_name: coverage_store_name) }.to raise_error(GeoServerSync::Error)
      end
    end
  end
end
