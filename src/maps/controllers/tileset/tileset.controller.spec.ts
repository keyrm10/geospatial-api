import { Test, TestingModule } from '@nestjs/testing'
import { TilesetController } from './tileset.controller'
import { BigQueryService, BigQueryServiceMock } from '../../services/bigquery.service'

describe('TilesetController', () => {
  let controller: TilesetController

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [TilesetController],
      providers: [
        {
          provide: BigQueryService,
          useClass: BigQueryServiceMock,
        }
      ],
    }).compile()

    controller = module.get<TilesetController>(TilesetController)
  })

  it('should be defined', () => {
    expect(controller).toBeDefined()
  })
})
