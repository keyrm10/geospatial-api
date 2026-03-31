import { z } from 'zod'

const TileQueryResult = z.object({
  z: z.string(),
  x: z.string(),
  y: z.string(),
  data: z.string(),
  carto_partition: z.string(),
})

export type TileQueryResult = z.infer<typeof TileQueryResult>
export function isTileQueryResult (result: any): result is TileQueryResult {
  return TileQueryResult.safeParse(result).success
}
