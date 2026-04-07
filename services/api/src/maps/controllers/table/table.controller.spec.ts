import { Test, TestingModule } from '@nestjs/testing'
import { BigQueryService, BigQueryServiceMock } from '../../services/bigquery.service'
import { TableController } from './table.controller'

describe('TableController', () => {
  let controller: TableController

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [TableController],
      providers: [
        {
          provide: BigQueryService,
          useClass: BigQueryServiceMock,
        }
      ],
    }).compile()

    controller = module.get<TableController>(TableController)
  })

  it('should be defined', () => {
    expect(controller).toBeDefined()
  })
})
