window.gen_srand = (seed) -> ->
  seed = (seed * 9301 + 49297) % 233280
  seed / 233280

window.getHue = (pct) -> pct * 140

window.nextpow2 = (num) ->
  Math.pow 2, Math.ceil( Math.log(num) / Math.log(2) )
