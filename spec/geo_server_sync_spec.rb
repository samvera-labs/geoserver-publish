# frozen_string_literal: true
RSpec.describe GeoServerSync do
  it "has a version number" do
    expect(GeoServerSync::VERSION).not_to be nil
  end

  describe "#publish_geotiff_layer" do
    let(:coverage) { instance_double(GeoServerSync::Coverage, create: true) }
    let(:coveragestore) { instance_double(GeoServerSync::CoverageStore, create: true) }
    let(:workspace) { instance_double(GeoServerSync::Workspace, create: true) }

    before do
      allow(GeoServerSync::Workspace).to receive(:new).and_return(workspace)
      allow(GeoServerSync::Coverage).to receive(:new).and_return(coverage)
      allow(GeoServerSync::CoverageStore).to receive(:new).and_return(coveragestore)
    end

    it "creates a workspace, coveragestore, and coverage layer" do
      described_class.publish_geotiff_layer(workspace_name: "public", file_path: "file:///raster.tif", id: "1234", title: "Title")
      expect(workspace).to have_received(:create)
      expect(coveragestore).to have_received(:create)
      expect(coverage).to have_received(:create)
    end
  end
end
