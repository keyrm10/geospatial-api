import { Injectable } from "@nestjs/common"
import { BigQueryHttpService, formatQueryResult } from "../clients/bigquery-http.service"
import { OutputFormat, formatResult } from "../utils/outputFormats"
import { isTileQueryResult } from "../utils/types"
import { ResultTooLargeError, ErrorUpstream } from "../utils/errors"
import { ConfigService } from "@nestjs/config"

@Injectable()
export class BigQueryService {
  private bigQueryHttpService: BigQueryHttpService

  constructor(private configService: ConfigService) {
    this.bigQueryHttpService = new BigQueryHttpService()
  }

  async getTable(tableName: string, format: OutputFormat, geomField: string) {
    const sql = `SELECT * FROM \`${tableName}\``
    const queryResult = await this.bigQueryHttpService.query(sql)
    if (queryResult.error) {
      throw new ErrorUpstream(JSON.stringify(queryResult))
    }
    if (!queryResult.rows) {
      return []
    }
    const formattedQueryResult = formatQueryResult(queryResult.rows, queryResult.schema.fields)
    const result = formatResult(formattedQueryResult, queryResult.schema.fields, format, geomField)
    
    // Check if result is too large
    if (Buffer.byteLength(JSON.stringify(result), 'utf8') > this.configService.get<number>('MAX_JSON_RESPONSE_SIZE')) {
      throw new ResultTooLargeError('Response is too large, it exceeds the maximum allowed size of 10MB')
    }

    return result
  }

  async getTile(tableName: string, z: string, x: string, y: string) {
    const sql = `SELECT * FROM \`${tableName}\` WHERE x = ${x} AND y = ${y} AND z = ${z}`
    const queryResult = await this.bigQueryHttpService.query(sql)

    // If no rows are returned, return null
    if (!queryResult.rows) {
      return null
    }

    const formattedQueryResult = formatQueryResult(queryResult.rows, queryResult.schema.fields)
    if (!isTileQueryResult(formattedQueryResult[0])) {
      throw new Error('Invalid tile query result')
    }
    return formattedQueryResult[0].data
  }
}


export class BigQueryServiceMock {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  async getTable(id: string, format: OutputFormat, geomField: string) {
    return 'Mocked table result'
  }
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  async getTile(tableName: string, z: string, x: string, y: string) {
    return 'Mocked tile result'
  }
}
