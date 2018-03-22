# frozen_string_literal: true
# # frozen_string_literal: true
# module GeoServerSync
#   class Catalog
#     attr_reader :config

#     def initialize(config = nil)
#       @config = config || GeoServerSync.config["geoserver"]
#     end

#     def connection
#       @connection ||= GeoServerSync::Connection.new(config)
#     end

#     def coverage; end

#     def coveragestore; end

#     def workspace
#       Workspace.new(connection)
#     end
#   end
# end
