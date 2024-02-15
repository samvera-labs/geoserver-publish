# frozen_string_literal: true
require "spec_helper"

RSpec.describe Geoserver::Publish::FeatureType do
  subject(:feature_type_object) { described_class.new }

  let(:base_url) { "http://localhost:8080/geoserver/rest" }
  let(:path) { "#{base_url}/workspaces/#{workspace_name}/datastores/#{data_store_name}/featuretypes/#{feature_type_name}" }
  let(:workspace_name) { "public" }
  let(:data_store_name) { "teststore" }
  let(:feature_type_name) { "testfeaturetype" }
  let(:title) { "title" }
  let(:params) do
    {
      workspace_name: workspace_name,
      data_store_name: data_store_name,
      feature_type_name: feature_type_name
    }
  end

  describe "#create" do
    let(:path) { "#{base_url}/workspaces/public/datastores/teststore/featuretypes" }
    let(:payload) { Fixtures.file_fixture("payload/feature_type.json").read }
    let(:params) do
      {
        workspace_name: workspace_name,
        data_store_name: data_store_name,
        feature_type_name: feature_type_name,
        title: title
      }
    end

    context "when a feature_type is created successfully" do
      before do
        stub_geoserver_post(path: path, payload: payload, status: 201)
      end

      it "returns a true" do
        expect(feature_type_object.create(**params)).to be true
      end
    end

    context "when a feature_type is not created successfully" do
      before do
        stub_geoserver_post(path: path, payload: payload, status: 500)
      end

      it "raises an exception" do
        expect { feature_type_object.create(**params) }.to raise_error(Geoserver::Publish::Error)
      end
    end

    context "allows for custom payload parameters to be added to the request" do
      let(:params) do
        {
          workspace_name: workspace_name,
          data_store_name: data_store_name,
          feature_type_name: feature_type_name,
          title: title,
          additional_payload: {
            metadata: {
              "cacheAgeMax" => 86_400,
              "cachingEnabled" => true
            }
          }
        }
      end

      it "creates a layer with additional payload" do
        new_payload = JSON.parse(payload)
        new_payload["featureType"].merge!(params[:additional_payload])
        stubbed = stub_geoserver_post(path: path, payload: new_payload.to_json, status: 201)
        feature_type_object.create(**params)
        expect(stubbed).to have_been_requested
      end
    end
  end

  describe "#update" do
    let(:payload) { Fixtures.file_fixture("payload/feature_type.json").read }
    let(:params) do
      {
        workspace_name: workspace_name,
        data_store_name: data_store_name,
        feature_type_name: feature_type_name,
        title: title,
        additional_payload: {
          metadata: {
            "cacheAgeMax" => 86_400,
            "cachingEnabled" => true
          }
        }
      }
    end

    context "with a 200 OK response" do
      it "makes a put request and returns true" do
        new_payload = JSON.parse(payload)
        new_payload["featureType"].merge!(params[:additional_payload])
        stub_geoserver_put(payload: new_payload.to_json, path: path, status: 200, content_type: "application/json")

        expect(feature_type_object.update(**params)).to be true
      end
    end

    context "with a 404 not found response" do
      let(:response) { "not found" }

      it "makes an update request to geoserver and raises an exception" do
        new_payload = JSON.parse(payload)
        new_payload["featureType"].merge!(params[:additional_payload])
        stub_geoserver_put(payload: new_payload.to_json, path: path, status: 404, content_type: "application/json")

        expect { feature_type_object.update(**params) }.to raise_error(Geoserver::Publish::Error)
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
        expect(feature_type_object.delete(**params)).to be true
      end
    end

    context "with a 404 not found response" do
      let(:response) { "not found" }

      before do
        stub_geoserver_delete(path: path, response: response, status: 404)
      end

      it "makes a delete request to geoserver and raises an exception" do
        expect { feature_type_object.delete(**params) }.to raise_error(Geoserver::Publish::Error)
      end
    end
  end

  describe "#find" do
    context "when a feature_type is found" do
      let(:response) { Fixtures.file_fixture("response/feature_type.json").read }

      before do
        stub_geoserver_get(path: path, response: response, status: 200)
      end

      it "returns a the properties as a hash" do
        expect(feature_type_object.find(**params)).to eq(JSON.parse(response))
      end
    end

    context "when a feature_type is not found" do
      let(:response) { "not found" }

      before do
        stub_geoserver_get(path: path, response: response, status: 404)
      end

      it "returns nil" do
        expect(feature_type_object.find(**params)).to be_nil
      end
    end
  end
end
