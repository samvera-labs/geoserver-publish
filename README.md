# Geoserver::Publish

[![Build Status](https://img.shields.io/travis/pulibrary/geoserver-publish/master.svg)](https://travis-ci.org/pulibrary/geoserver-publish)
[![Coverage Status](https://img.shields.io/coveralls/pulibrary/geoserver-publish/master.svg)](https://coveralls.io/github/pulibrary/geoserver-publish?branch=master)

Simple client for publishing Shapefiles and GeoTIFFs to Geoserver.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'geoserver-publish'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install geoserver-publish

## Usage

#### GeoTIFF

```ruby
Geoserver::Publish.geotiff(workspace_name: "public", file_path: "file:///path/on/geoserver/raster.tif", id: "1234", title: "GeoTiff Title")
```

#### Shapefile

Because of a limitation in GeoServer, the layer id  must be the same name as the shapefile without the extenstion. For example, if the file name is `1234.shp`, the id must be `1234`.

```ruby
Geoserver::Publish.shapefile(workspace_name: "public", file_path: "file:///path/on/geoserver/1234.shp", id: "1234", title: "Shapefile Title")
```

#### Deleting

```Ruby
Geoserver::Publish.delete_geotiff(workspace_name: "public", id: "1234")
Geoserver::Publish.delete_shapefile(workspace_name: "public", id: "1234")
```

## Configuration

#### Default

To use the default GeoServer connection parameters, no further configuration is needed. These are useful for testing and development against a local GeoServer instance.

 - url: http://localhost:8080/geoserver/rest
 - user: admin
 - password: geoserver


#### Environment Variables

GeoServer Connection parameters can be set using environment variables.

  - GEOSERVER_URL
  - GEOSERVER_USER
  - GEOSERVER_PASSWORD

#### Connection Object

A connection object can be instantiated with a parameter hash and passed into publishing methods.

```ruby
new_conn = Geoserver::Publish::Connection.new({"url"=> "http://mygeoserver.com:8181/geoserver/rest", "user" => "admin_user", "password" => "supersecret"})
Geoserver::Publish.geotiff(connection: new_conn, workspace_name: "public", file_path: "file:///path/on/geoserver/raster.tif", id: "1234", title: "GeoTiff Title")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pulibrary/geoserver-publish.
