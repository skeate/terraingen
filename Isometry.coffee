###
#  +-------------- x
#  |
#  |   S  #   W 
#  |    #   #
#  |  #       #
#  |    #   #
#  |   E  #   N
#  |
#  y
#
#
# width is E-W
# depth is N-S
# height is orthogonal to both of course
# 
# if iso grid is 3x5,
#   (0,0) is SW corner
#   (3,0) is SE corner
#   (0,5) is NW corner
#   (3,5) is NE corner
###
class window.Isometry

  #`relativeTo` is which part of the tile to give cartesian coordinates relative
  #to. It can be a corner (e.g. "SW"), or "center".

  constructor: (@gridWidth, @gridDepth, @gridHeight, @tileWidth, @tileDepth, @tileHeight, @relativeTo) ->
    @cartesianTileWidth = @tileWidth + @tileDepth
    @cartesianTileHeight = Math.max(@tileWidth, @tileDepth)
    @cartesianWidth = (@gridWidth + @gridDepth)/2 * @cartesianTileWidth
    @cartesianHeight = (@gridWidth + @gridDepth)/2 * @cartesianTileHeight + @gridHeight * @tileHeight
    @x0 = (@gridWidth)/2 * @cartesianTileWidth
    @y0 = @gridHeight * @tileHeight
    switch @relativeTo
      when "SW" then
      when "SE"
        @x0 -= @cartesianTileWidth / 2
        @y0 += @cartesianTileHeight / 2
        break
      when "NW"
        @x0 += @cartesianTileWidth / 2
        @y0 += @cartesianTileHeight / 2
      when "NE"
        @y0 += @cartesianTileHeight
      when "center"
        @y0 += @cartesianTileHeight / 2
      else throw new Exception 'Unknown relativeTo value'

  getX: (isoX, isoY, isoZ) ->
    @x0 - (isoX * @tileWidth) + (isoY * @tileDepth)
  getY: (isoX, isoY, isoZ) ->
    @y0 - (isoZ * @tileHeight) + (isoX * @tileWidth/2) + (isoY * @tileDepth/2)
