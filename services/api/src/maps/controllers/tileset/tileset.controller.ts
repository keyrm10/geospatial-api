import { Controller, Get, Param, Res, StreamableFile } from '@nestjs/common'
import { BigQueryService } from '../../services/bigquery.service'
import type {  } from '@nestjs/platform-fastify'
import { FastifyReply } from 'fastify'

@Controller('maps/tileset')
export class TilesetController {

  constructor(private bigQueryService: BigQueryService) { }

  @Get('/:id/:z/:x/:y')
  async getTile(
    @Param('id') id: string,
    @Param('z') z: string,
    @Param('x') x: string,
    @Param('y') y: string,
    @Res({ passthrough: true }) res: FastifyReply
  ) {
    const result = await this.bigQueryService.getTile(id, z, x, y)
    if (!result) {
      res.status(204)
      return null
    }
    res.header('Content-Type', 'application/vnd.mapbox-vector-tile')
    res.header('Content-Encoding', 'gzip')
    return new StreamableFile(Buffer.from(result, 'base64'))
  }
}
