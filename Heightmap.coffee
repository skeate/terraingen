class window.PerlinHeightmap extends Matrix
  constructor: (width, depth, maxHeight, @seed=Math.floor(Math.random()*500), detail=4, persistence=1) ->
    # We want to generate a square that will support our detail
    # from which we can take a width x depth sized chunk.
    # The square dimension should be a power of two to iterate over
    # down to the individual element level.
    dim = Math.max nextpow2(Math.max(width, depth)), Math.pow(2,detail-1)
    super dim, dim
    start = Math.log(dim) / Math.log(2) - detail + 1

    rand = gen_srand(@seed)
    maxH = 0
    for i in [0..detail-1]
      regionDim = Math.pow(2,start+i)
      size = dim/regionDim
      maxH += Math.pow(persistence, i)
      for x in [0..regionDim-1]
        for y in [0..regionDim-1]
          adjustment = rand() * Math.pow(persistence, i)
          @setArea size, size, x, y, (val) -> val + adjustment
    @mat = @mat.map (val) ->
      if val < 1 then 1
      else 1+Math.floor((val-1)/(maxH) * maxHeight)
    @map = @getArea width, depth


class window.DescendingHeightmap extends Matrix
  constructor: (width, depth, maxHeight, @seed=Math.floor(Math.random()*500), inclineChance = .1, maxDrop = 5) ->
    rand = new MersenneTwister @seed
    super width, depth

    # 0 = SW hill (SW corner is high point, slope down all dirs)
    # 1 = S hill (slope S->N)
    # 2 = W hill (slope W->N)
    # 3 = NE valley (
    type = Math.floor(rand.random() * 4)

    for y in [0..depth-1]
      for x in [0..width-1]
        height_south = @get x, y-1
        height_west = @get x-1, y
        if ( x == 0 and y == 0 ) or
           ( x == 0 and ( type == 2 or type == 3 ) ) or
           ( y == 0 and ( type == 1 or type == 3 ) )
          height_south = maxHeight
          height_west = maxHeight
        else if x == 0
          height_west = height_south
        else if y == 0
          height_south = height_west
        newh = Math.floor((height_south + height_west)/2 - ((rand.random() - inclineChance)*maxDrop))
        newh = Math.max newh, 1
        @set x, y, Math.min newh, maxHeight
    @map = @getArea width, depth
