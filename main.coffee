width = window.innerWidth
height = window.innerHeight
stage = new PIXI.Stage 0xefffff
world = new PIXI.DisplayObjectContainer()
world.interactive = true
world.mousedown = (a) ->
  if a.originalEvent.button == 1
    console.log "(#{@x}, #{@y})"
    @moving = true
world.mouseup = (a) ->
  if a.originalEvent.button == 1
    @moving = false
world.mousemove = (a) ->
  if @moving
    @x += a.originalEvent.movementX
    @y += a.originalEvent.movementY
renderer = PIXI.autoDetectRenderer width, height
document.body.appendChild renderer.view

loader = new PIXI.AssetLoader ['images/tiles.json']

terrain = new Heightmap 5, 10, 10
iso = new Isometry terrain.map.width, terrain.map.height, 20, 50, 50, 15, 'NE'
console.log "render width: "+iso.cartesianWidth
console.log "page width: "+width

isoTile = (file) -> (x, y) ->
  tile = PIXI.Sprite.fromFrame file
  tile.position.x = x
  tile.position.y = y

  tile.anchor.x = 0
  tile.anchor.y = 1
  #hit = new PIXI.Polygon [0,-15, 50,-40, 0,-65, -50,-40, 0,-15]
  #tile.hitArea = hit
  #tile.interactive = true
  #tile.mouseover = ->
    #if @tint == 0xFFFFFF
      #@tint = 0xFFAAAA
  #tile.mouseout = ->
      #@tint = 0xFFFFFF
  world.addChild tile

grass = isoTile 'grass'
dirt = isoTile 'dirtDouble'
hillN = isoTile 'hillN'
hillE = isoTile 'hillE'
hillS = isoTile 'hillS'
hillW = isoTile 'hillW'

drawMap = (terrain, xOffset, yOffset) ->
  for x in [0..terrain.map.width-1] by 1
    row = "#{x}: "
    for y in [0..terrain.map.height-1] by 1
      tileHeight = terrain.map.get x, y
      neighbors = [
        { dir: "north", height: if y < terrain.map.height-1 then terrain.map.get x, y+1 else null }
        { dir: "east", height: if x < terrain.map.width-1 then terrain.map.get x+1, y else null }
        { dir: "south", height: if y > 1 then terrain.map.get x, y-1 else null }
        { dir: "west", height: if x > 1 then terrain.map.get x-1, y else null }
      ]
      neighbors = neighbors.map (n) ->
        newN = dir: n.dir
        if n.height?
          newN.height = (n.height - tileHeight)
        else
          newN.height = -20
        newN
      row+=tileHeight+","
      for z in [0..tileHeight-2] by 1
        dirt iso.getX(x,y,z)+xOffset, iso.getY(x,y,z)+yOffset
      neighbors.sort (a,b) ->
        if a.height > b.height then -1
        else if a.height < b.height then 1
        else 0
      tile = grass
      for neighbor in neighbors
        if neighbor.height == 1
          switch neighbor.dir
            when "north" then tile = hillN
            when "east" then tile = hillE
            when "south" then tile = hillS
            when "west" then tile = hillW
          break
      tile iso.getX(x,y,z)+xOffset, iso.getY(x,y,z)+yOffset
    console.log row

loader.onComplete = ->
  drawMap terrain, (width-iso.cartesianWidth)/2, (height-iso.cartesianHeight)/2
  stage.addChild world
  animate = ->
    requestAnimFrame animate
    renderer.render stage
  requestAnimFrame animate
loader.load()

document.getElementById("redraw").addEventListener "click", ->
  _width = document.getElementById("userWidth").value
  _depth = document.getElementById("userDepth").value
  while world.children.length
    world.removeChild world.getChildAt 0
  terrain = new Heightmap _width, _depth, 20
  drawMap terrain, (width-iso.cartesianWidth)/2, (height-iso.cartesianHeight)/2
