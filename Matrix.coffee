class window.Matrix
  constructor: (@width, @height) ->
    @mat = new Array @width*@height
    for i in [0..@mat.length-1]
        @mat[i] = 0
  get: (x,y) ->
    if x < 0 or y < 0 or x >= @width or y >= @height
      undefined
    else
      @mat[y*@width+x]
  set: (x,y,val) ->
    @mat[y*@width+x] = val
  max: ->
    Math.max.apply null, @mat
  min: ->
    Math.min.apply null, @mat
  getArea: (areaWidth, areaHeight) ->
    newMat = new Matrix(areaWidth,areaHeight)
    for y in [0..areaHeight-1] by 1
        for x in [0..areaWidth-1] by 1
            newMat.set(x,y,@get(x,y))
    newMat
  setArea: (areaWidth, areaHeight, x, y, func) ->
    xOffset = x * areaWidth
    yOffset = y * areaHeight
    for y in [0..areaHeight-1] by 1
      for x in [0..areaWidth-1] by 1
        @set(xOffset + x, yOffset + y, func(@get(xOffset + x, yOffset + y)))
