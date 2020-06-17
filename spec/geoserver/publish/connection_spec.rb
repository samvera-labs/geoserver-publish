# frozen_string_literal: true
require "spec_helper"

RSpec.describe Geoserver::Publish::Connection do
  subject(:connection) { described_class.new(config) }

  let(:base_url) { "http://localhost:8080/geoserver/rest" }
  let(:config) do
    {
      "url" => "http://localhost:8080/geoserver/rest",
      "user" => "admin",
      "password" => "geoserver"
    }
  end

  describe "#delete" do
    let(:path) { "#{base_url}/workspaces/public" }
    let(:response) { "" }

    context "with a 200 OK response" do
      before do
        stub_geoserver_delete(path: path, response: response, status: 200)
      end

      it "makes a delete request and returns true" do
        expect(connection.delete(path: path)).to be true
      end
    end

    context "with a 404 not found response" do
      let(:response) { "Not found" }

      before do
        stub_geoserver_delete(path: path, response: response, status: 404)
      end

      it "makes a delete request to geoserver and raises an exception" do
        expect { connection.delete(path: path) }.to raise_error(Geoserver::Publish::Error)
      end
    end
  end

  describe "#get" do
    let(:path) { "#{base_url}/workspaces" }
    let(:response) { '{"workspaces":[]}' }

    context "with a 200 OK response" do
      before do
        stub_geoserver_get(path: path, response: response, status: 200)
      end

      it "makes a get request to geoserver and returns response" do
        expect(connection.get(path: path)).to eq(response)
      end
    end

    context "with a 404 not found response" do
      let(:response) { "Not found" }

      before do
        stub_geoserver_get(path: path, response: response, status: 404)
      end

      it "makes a get request to geoserver and returns nil" do
        expect(connection.get(path: path)).to be_nil
      end
    end
  end

  describe "#post" do
    let(:path) { "#{base_url}/workspaces" }
    let(:payload) { '{"workspace":{"name":"public"}}' }

    context "with a 201 created response" do
      before do
        stub_geoserver_post(path: path, payload: payload, status: 201)
      end

      it "makes a post request to geoserver and returns true" do
        expect(connection.post(path: path, payload: payload)).to be true
      end
    end

    context "with a 401 response, resource already exists" do
      before do
        stub_geoserver_post(path: path, payload: payload, status: 401)
      end

      it "makes a post request to geoserver and returns true" do
        expect(connection.post(path: path, payload: payload)).to be true
      end
    end

    context "with a 500 response, server error" do
      before do
        stub_geoserver_post(path: path, payload: payload, status: 500)
      end

      it "makes a post request to geoserver and raises an exception" do
        expect { connection.post(path: path, payload: payload) }.to raise_error(Geoserver::Publish::Error)
      end
    end
  end
  
  describe "#put" do
    let(:path) { "#{base_url}/workspaces/public.json" }
    let(:payload) { '{"workspace":{"name":"public","isolated":true}}' }
    let(:content_type) { 'application/json' }

    context "with a 200 updated response" do
      before do
        stub_geoserver_put(path: path, payload: payload, content_type: content_type, status: 200)
      end

      it "makes a put request to geoserver and returns true" do
        expect(connection.put(path: path, payload: payload, content_type: 'application/json')).to be true
      end
    end

    context "with a 500 response, server error" do
      before do
        stub_geoserver_put(path: path, payload: payload, content_type: content_type, status: 500)
      end

      it "makes a put request to geoserver and raises an exception" do
        expect { connection.put(path: path, payload: payload, content_type: 'application/json') }.to raise_error(Geoserver::Publish::Error)
      end
    end
  end
end
