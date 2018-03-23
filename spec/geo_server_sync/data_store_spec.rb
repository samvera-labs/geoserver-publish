# frozen_string_literal: true
require "spec_helper"

RSpec.describe GeoServerSync::DataStore do
  subject(:datastore_object) { described_class.new }

  let(:base_url) { "http://localhost:8080/geoserver/rest" }
  let(:path) { "#{base_url}/workspaces/#{workspace_name}/datastores/#{data_store_name}" }
  let(:workspace_name) { "public" }
  let(:data_store_name) { "datastore" }
  let(:url) { "file:///shapefile.shp" }

  describe "#create" do
    let(:path) { "#{base_url}/workspaces/public/datastores" }
    let(:payload) { Fixtures.file_fixture("payload/datastore.json").read }

    context "when a datastore is created successfully" do
      before do
        stub_geoserver_post(path: path, payload: payload, status: 201)
      end

      it "returns a the properties as a hash" do
        expect(datastore_object.create(workspace_name: workspace_name, data_store_name: data_store_name, url: url)).to be true
      end
    end

    context "when a datastore is not created successfully" do
      before do
        stub_geoserver_post(path: path, payload: payload, status: 500)
      end

      it "raises an exception" do
        expect { datastore_object.create(workspace_name: workspace_name, data_store_name: data_store_name, url: url) }.to raise_error(GeoServerSync::Error)
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
        expect(datastore_object.delete(workspace_name: workspace_name, data_store_name: data_store_name)).to be true
      end
    end

    context "with a 404 not found response" do
      let(:response) { "not found" }

      before do
        stub_geoserver_delete(path: path, response: response, status: 404)
      end

      it "makes a delete request to geoserver and raises an exception" do
        expect { datastore_object.delete(workspace_name: workspace_name, data_store_name: data_store_name) }.to raise_error(GeoServerSync::Error)
      end
    end
  end

  describe "#find" do
    context "when a datastore is found" do
      let(:response) { Fixtures.file_fixture("response/datastore.json").read }

      before do
        stub_geoserver_get(path: path, response: response, status: 200)
      end

      it "returns a the properties as a hash" do
        expect(datastore_object.find(workspace_name: workspace_name, data_store_name: data_store_name)).to eq(JSON.parse(response))
      end
    end

    context "when a datastore is not found" do
      let(:response) { "not found" }

      before do
        stub_geoserver_get(path: path, response: response, status: 404)
      end

      it "raises an exception" do
        expect { datastore_object.find(workspace_name: workspace_name, data_store_name: data_store_name) }.to raise_error(GeoServerSync::Error)
      end
    end
  end
end
