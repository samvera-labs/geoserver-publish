# frozen_string_literal: true
require "spec_helper"

RSpec.describe GeoServerSync::Coverage do
  subject(:coverage_object) { described_class.new }

  let(:base_url) { "http://localhost:8080/geoserver/rest" }
  let(:path) { "#{base_url}/workspaces/#{workspace_name}/coveragestores/#{coverage_store_name}/coverages/#{coverage_name}" }
  let(:workspace_name) { "public" }
  let(:coverage_store_name) { "teststore" }
  let(:coverage_name) { "testcov" }
  let(:title) { "title" }

  describe "#create" do
    let(:path) { "#{base_url}/workspaces/public/coveragestores/teststore/coverages" }
    let(:payload) { '{"coverage":{"enabled":true,"name":"testcov","title":"title"}}' }

    context "when a coverage is created successfully" do
      before do
        stub_geoserver_post(path: path, payload: payload, status: 201)
      end

      it "returns a true" do
        expect(coverage_object.create(workspace_name: workspace_name,
                                      coverage_store_name: coverage_store_name,
                                      coverage_name: coverage_name,
                                      title: title)).to be true
      end
    end

    context "when a coverage is not created successfully" do
      before do
        stub_geoserver_post(path: path, payload: payload, status: 500)
      end

      it "raises an error" do
        expect { coverage_object.create(workspace_name: workspace_name, coverage_store_name: coverage_store_name, coverage_name: coverage_name, title: title) }.to raise_error(GeoServerSync::Error)
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
        expect(coverage_object.delete(workspace_name: workspace_name, coverage_store_name: coverage_store_name, coverage_name: coverage_name)).to be true
      end
    end

    context "with a 404 not found response" do
      let(:response) { "not found" }

      before do
        stub_geoserver_delete(path: path, response: response, status: 404)
      end

      it "makes a delete request to geoserver and raises an exception" do
        expect { coverage_object.delete(workspace_name: workspace_name, coverage_store_name: coverage_store_name, coverage_name: coverage_name) }.to raise_error(GeoServerSync::Error)
      end
    end
  end

  describe "#find" do
    context "when a coverage is found" do
      let(:response) { '{"workspace":{"name":"public","isolated":false}}' }

      before do
        stub_geoserver_get(path: path, response: response, status: 200)
      end

      it "returns a the properties as a hash" do
        expect(coverage_object.find(workspace_name: workspace_name, coverage_store_name: coverage_store_name, coverage_name: coverage_name)).to eq(JSON.parse(response))
      end
    end

    context "when a coverage is not found" do
      let(:response) { "not found" }

      before do
        stub_geoserver_get(path: path, response: response, status: 404)
      end

      it "raises an exception" do
        expect { coverage_object.find(workspace_name: workspace_name, coverage_store_name: coverage_store_name, coverage_name: coverage_name) }.to raise_error(GeoServerSync::Error)
      end
    end
  end
end
