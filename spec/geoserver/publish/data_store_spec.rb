# frozen_string_literal: true
require "spec_helper"

RSpec.describe Geoserver::Publish::DataStore do
  subject(:datastore_object) { described_class.new }

  let(:base_url) { "http://localhost:8080/geoserver/rest" }
  let(:path) { "#{base_url}/workspaces/#{workspace_name}/datastores/#{data_store_name}" }
  let(:workspace_name) { "public" }
  let(:data_store_name) { "datastore" }
  let(:url) { "file:///shapefile.shp" }
  let(:params) do
    {
      workspace_name: workspace_name,
      data_store_name: data_store_name
    }
  end

  describe "#create" do
    let(:path) { "#{base_url}/workspaces/public/datastores" }
    let(:payload) { Fixtures.file_fixture("payload/datastore.json").read }
    let(:params) do
      {
        workspace_name: workspace_name,
        data_store_name: data_store_name,
        url: url
      }
    end

    context "when a datastore is created successfully" do
      before do
        stub_geoserver_post(path: path, payload: payload, status: 201)
      end

      it "returns true" do
        expect(datastore_object.create(params)).to be true
      end
    end

    context "when a datastore is not created successfully" do
      before do
        stub_geoserver_post(path: path, payload: payload, status: 500)
      end

      it "raises an exception" do
        expect { datastore_object.create(params) }.to raise_error(Geoserver::Publish::Error)
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
        expect(datastore_object.delete(params)).to be true
      end
    end

    context "with a 404 not found response" do
      let(:response) { "not found" }

      before do
        stub_geoserver_delete(path: path, response: response, status: 404)
      end

      it "makes a delete request to geoserver and raises an exception" do
        expect { datastore_object.delete(params) }.to raise_error(Geoserver::Publish::Error)
      end
    end
  end

  describe "#find" do
    context "when a datastore is found" do
      let(:response) { Fixtures.file_fixture("response/datastore.json").read }

      before do
        stub_geoserver_get(path: path, response: response, status: 200)
      end

      it "returns the properties as a hash" do
        expect(datastore_object.find(params)).to eq(JSON.parse(response))
      end
    end

    context "when a datastore is not found" do
      let(:response) { "not found" }

      before do
        stub_geoserver_get(path: path, response: response, status: 404)
      end

      it "returns nil" do
        expect(datastore_object.find(params)).to be_nil
      end
    end
  end
  
  describe "#upload" do
    let(:path) { "#{base_url}/workspaces/public/datastores/datastore/file.shp" }
    let(:payload) { Fixtures.file_fixture("payload/antarctica-latest-free.shp.zip").read }
    let(:content_type) { 'application/zip' }
    let(:params) do
      {
        workspace_name: workspace_name,
        data_store_name: data_store_name,
        file: payload
      }
    end

    context "when a datastore is created successfully" do
      before do
        stub_geoserver_put(path: path, payload: payload, content_type: content_type, status: 200)
      end

      it "returns true" do
         expect(datastore_object.upload(params)).to be true
      end
    end

    context "when a datastore is not created successfully" do
      before do
        stub_geoserver_put(path: path, payload: payload, content_type: content_type, status: 500)
      end

      it "raises an exception" do
        expect { datastore_object.upload(params) }.to raise_error(Geoserver::Publish::Error)
      end
    end
  end
end
