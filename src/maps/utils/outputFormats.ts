import { parse } from 'wkt'
import { BigQueryResponseSchemaField } from '../clients/bigquery-http.service'
import { FormatNotSupportedError } from './errors'

export enum OutputFormat {
  GEOJSON = "geojson"
}

function transformToGeoJSON(rows: Record<string, unknown>[], geomField: string) {
  const features = rows.map(row => {
    const geometry = parse(row[geomField])
    return {
      type: 'Feature',
      geometry,
      properties: row,
    }
  }
  )
  return {
    type: 'FeatureCollection',
    features
  }
}

export function formatResult(result: Record<string, unknown>[], schema: BigQueryResponseSchemaField[], format: OutputFormat, geomField: string) {
  switch (format) {
    case OutputFormat.GEOJSON:
      return transformToGeoJSON(result, geomField)
    default:
      throw new FormatNotSupportedError(`Format ${format} not supported`)
  }
}
