# frozen_string_literal: true
require "spec_helper"

RSpec.describe Geoserver::Publish::Workspace do
  subject(:workspace_object) { described_class.new }
  let(:base_url) { "http://localhost:8080/geoserver/rest" }
  let(:path) { "#{base_url}/workspaces/#{workspace_name}" }
  let(:workspace_name) { "public" }

  describe "#create" do
    let(:path) { "#{base_url}/workspaces" }
    let(:payload) { Fixtures.file_fixture("payload/workspace.json").read }

    context "when a workspace is created successfully" do
      before do
        stub_geoserver_post(path: path, payload: payload, status: 201)
      end

      it "returns a true" do
        expect(workspace_object.create(workspace_name: workspace_name)).to be true
      end
    end

    context "when a workspace is not created successfully" do
      before do
        stub_geoserver_post(path: path, payload: payload, status: 500)
      end

      it "raises an error" do
        expect { workspace_object.create(workspace_name: workspace_name) }.to raise_error(Geoserver::Publish::Error)
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
        expect(workspace_object.delete(workspace_name: workspace_name)).to be true
      end
    end

    context "with a 404 not found response" do
      let(:response) { "not found" }

      before do
        stub_geoserver_delete(path: path, response: response, status: 404)
      end

      it "makes a delete request to geoserver and raises an exception" do
        expect { workspace_object.delete(workspace_name: workspace_name) }.to raise_error(Geoserver::Publish::Error)
      end
    end
  end

  describe "#find" do
    context "when a workspace is found" do
      let(:response) { Fixtures.file_fixture("response/workspace.json").read }

      before do
        stub_geoserver_get(path: path, response: response, status: 200)
      end

      it "returns a the properties as a hash" do
        expect(workspace_object.find(workspace_name: workspace_name)).to eq(JSON.parse(response))
      end
    end

    context "when a workspace is not found" do
      let(:response) { "not found" }

      before do
        stub_geoserver_get(path: path, response: response, status: 404)
      end

      it "returns nil" do
        expect(workspace_object.find(workspace_name: workspace_name)).to be_nil
      end
    end
  end
end
