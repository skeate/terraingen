class window.Heightmap extends Matrix
  constructor: (width, depth, maxHeight, @seed=Math.floor(Math.random()*500), detail=4, persistence=1) ->
    # We want to generate a square that will support our detail
    # from which we can take a width x depth sized chunk.
    # The square dimension should be a power of two to iterate over
    # down to the individual element level.
    dim = Math.max nextpow2(Math.max(width, depth)), Math.pow(2,detail-1)
    super dim, dim
    start = Math.log(dim) / Math.log(2) - detail + 1

    rand = gen_srand(@seed)
    for i in [0..detail-1]
      regionDim = Math.pow(2,start+i)
      size = dim/regionDim
      for x in [0..regionDim-1]
        for y in [0..regionDim-1]
          adjustment = rand() * Math.pow(persistence, i)
          @setArea size, size, x, y, (val) -> val + adjustment
    @mat = @mat.map (val) ->
      if val < 1 then 1
      else 1 + Math.floor((val-1)/(detail-1) * maxHeight)
    @map = @getArea width, depth
