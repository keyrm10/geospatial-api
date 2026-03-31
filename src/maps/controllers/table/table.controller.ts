import { BadRequestException, Controller, Get, HttpException, Param, Query } from '@nestjs/common'
import { BigQueryService } from '../../services/bigquery.service'
import { ErrorUpstream, FormatNotSupportedError, ResultTooLargeError } from '../../utils/errors'
import { OutputFormat } from '../../utils/outputFormats'

@Controller('maps/table')
export class TableController {

  constructor(private bigQueryService: BigQueryService) { }

  @Get(':id')
  async getTable(@Param('id') id: string, @Query('geomField') geomField: string, @Query('format') format: OutputFormat) {
    try {
      if (!geomField) {
        throw new BadRequestException('geomField is required')
      }
      const result = await this.bigQueryService.getTable(id, format, geomField)
      return result
    } catch (error) {
      if (error instanceof FormatNotSupportedError) {
        throw new BadRequestException(error.message)
      }
      if (error instanceof ResultTooLargeError) {
        throw new HttpException(error.message, 413)
      }
      if (error instanceof ErrorUpstream) {
        throw new HttpException(error.message, 400)
      }
      throw new HttpException(error.message, 500)
    }
  }
}
