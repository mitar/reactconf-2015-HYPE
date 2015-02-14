dark = (r, g, b) ->
  # YIQ equation from http://24ways.org/2010/calculating-color-contrast
  yiq = (r * 299 + g * 587 + b * 114) / 1000
  yiq < 128

light = (r, g, b) ->
  not dark r, g, b

@Colors = createStore (id) ->
  result = new ReactiveVar null

  img = new Image()
  img.onload = ->
    thief = new ColorThief()
    [r, g, b] = thief.getColor img
    bg = "rgb(#{r}, #{g}, #{b})"
    fg = if light r, g, b then '#000' else '#fff'
    result.set {bg, fg}
  img.src = BOB[id]

  result
