## Description

This sample API implements a basic map tiler. It connects to the Google BigQuery (BQ) provided by the client in the request URL.
To keep it simple, this API is going to use the default google credentials configured on the instance and, from that default credentials is going to also use the BQ billing account.

API done with [Nest](https://github.com/nestjs/nest) framework. It requires Node.js >= 18.10 to be executed.

This API exposes two endpoints:

* http://localhost:3000/maps/tileset/:tileset_table_name/{z}/{x}/{y}: It returns a tile from a generated tileset in MVT format.

* http://localhost:3000/maps/table/:table_name?geomField=geom&format=geojson It returns a GeoJSON with the rows of the table. Please, take into account that the query parameters are obligatory.

The API obtains an access token for GCP using the default application credentials configured in the environment. It uses these credentials to connect to BigQuery and obtain the data.

## Installation

```bash
$ yarn install
```

## Running the app

```bash
# development
$ yarn run start

# watch mode
$ yarn run start:dev

# production mode
$ yarn run start:prod
```

## Test

```bash
# unit tests
$ yarn run test
```

## Dev notes
In order to test the API you can use the following endpoints:

- http://localhost:3000/maps/tileset/carto-demo-data.demo_tilesets.covid19_vaccinated_usa_tileset/{z}/{x}/{y}. Usage example: http://localhost:3000/maps/tileset/carto-demo-data.demo_tilesets.covid19_vaccinated_usa_tileset/3/0/2
- http://localhost:3000/maps/table/carto-demo-data.demo_tables.retail_stores?geomField=geom&format=geojson

And the following JSFiddles to visualize (You should adapt the url to your local environment):

- Tiles: https://jsfiddle.net/by1n8a0z/5/
- GeoJSON: https://jsfiddle.net/3c2vhtsq/4/
