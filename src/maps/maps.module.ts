import { Module } from '@nestjs/common'
import { TableController } from './controllers/table/table.controller'
import { BigQueryService } from './services/bigquery.service'
import { TilesetController } from './controllers/tileset/tileset.controller'

@Module({
  controllers: [TableController, TilesetController],
  providers: [BigQueryService]
})
export class MapsModule { }
