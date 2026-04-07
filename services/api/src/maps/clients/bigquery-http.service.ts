import { GoogleAuth } from 'google-auth-library'

const baseUrl = 'https://bigquery.googleapis.com'
const bigQueryScopes = ['https://www.googleapis.com/auth/bigquery']
const projectId = 'carto-dw-ac-5p2hp46q'

export type BigQueryResponseSchemaField = {
  name: string
  type: string
  mode: string
}

export type BigQueryResponseRowField = {
  f: {
    v: string
  }
}

type BigQueryResponse = {
  kind: string
  schema: {
    fields: BigQueryResponseSchemaField[]
  },
  jobReference: {
    projectId: string
    jobId: string
    location: string
  },
  totalRows: string
  rows: BigQueryResponseRowField[],
  totalBytesProcessed: string
  jobComplete: boolean
  error: any
}

export class BigQueryHttpService {
  private projectId: string = projectId

  async query(sql: string, options?: Record<string, string | boolean>): Promise<BigQueryResponse> {
    const accessToken = await this.getAccessToken()
    const result = await this._fetch<BigQueryResponse>(`${baseUrl}/bigquery/v2/projects/${this.projectId}/queries`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify({
        query: sql,
        useLegacySql: false,
        ...options
      })
    })
    return result
  }

  private async getAccessToken() {
    const auth = new GoogleAuth({
      scopes: bigQueryScopes,
    })
    return await auth.getAccessToken()
  }

  private async _fetch<T>(url: string, options: RequestInit): Promise<T> {
    const response = await fetch(url, options)
    const result = await response.json()
    return result
  }
}

export function formatQueryResult(queryResult: BigQueryResponseRowField[], schema: BigQueryResponseSchemaField[]) {
  return queryResult.map(row => {
    const formattedRow = {}
    schema.forEach((field, index) => {
      formattedRow[field.name] = row.f[index].v
    })
    return formattedRow
  })
}
