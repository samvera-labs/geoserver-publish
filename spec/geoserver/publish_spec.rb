# frozen_string_literal: true
RSpec.describe Geoserver::Publish do
  it "has a version number" do
    expect(Geoserver::Publish::VERSION).not_to be nil
  end

  describe "#delete_geotiff" do
    let(:coveragestore) { instance_double(Geoserver::Publish::CoverageStore, delete: true) }

    before do
      allow(Geoserver::Publish::CoverageStore).to receive(:new).and_return(coveragestore)
    end

    it "deletes a geotiff coveragestore and it's coverage layer" do
      described_class.delete_geotiff(workspace_name: "public", id: "1234")
      expect(coveragestore).to have_received(:delete)
    end
  end

  describe "#delete_shapefile" do
    let(:data_store) { instance_double(Geoserver::Publish::DataStore, delete: true) }

    before do
      allow(Geoserver::Publish::DataStore).to receive(:new).and_return(data_store)
    end

    it "deletes a shapefile data_store and it's feature layer" do
      described_class.delete_shapefile(workspace_name: "public", id: "1234")
      expect(data_store).to have_received(:delete)
    end
  end

  describe "#geotiff" do
    let(:coverage) { instance_double(Geoserver::Publish::Coverage, create: true, find: nil) }
    let(:coveragestore) { instance_double(Geoserver::Publish::CoverageStore, create: true, find: nil) }
    let(:workspace) { instance_double(Geoserver::Publish::Workspace, create: true, find: nil) }

    before do
      allow(Geoserver::Publish::Workspace).to receive(:new).and_return(workspace)
      allow(Geoserver::Publish::Coverage).to receive(:new).and_return(coverage)
      allow(Geoserver::Publish::CoverageStore).to receive(:new).and_return(coveragestore)
    end

    it "creates a workspace, coveragestore, and coverage layer" do
      described_class.geotiff(workspace_name: "public", file_path: "file:///raster.tif", id: "1234", title: "Title")
      expect(workspace).to have_received(:create)
      expect(coveragestore).to have_received(:create)
      expect(coverage).to have_received(:create)
    end
  end

  describe "#shapefile" do
    let(:feature_type) { instance_double(Geoserver::Publish::FeatureType, create: true, find: nil) }
    let(:data_store) { instance_double(Geoserver::Publish::DataStore, create: true, find: nil) }
    let(:workspace) { instance_double(Geoserver::Publish::Workspace, create: true, find: nil) }

    before do
      allow(Geoserver::Publish::Workspace).to receive(:new).and_return(workspace)
      allow(Geoserver::Publish::FeatureType).to receive(:new).and_return(feature_type)
      allow(Geoserver::Publish::DataStore).to receive(:new).and_return(data_store)
    end

    it "creates a workspace, data_store, and feature_type layer" do
      described_class.shapefile(workspace_name: "public", file_path: "file:///1234.shp", id: "1234", title: "Title")
      expect(workspace).to have_received(:create)
      expect(data_store).to have_received(:create)
      expect(feature_type).to have_received(:create)
    end
  end
end
