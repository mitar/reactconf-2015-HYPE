IMAGE_SIZE = 100
IMAGE_MARGIN = 10

viewportWidth = new ReactiveVar $(window).width()

Meteor.startup ->
  $(window).resize (event) ->
    viewportWidth.set $(window).width()
    return

calcAlbumsPerRow = ->
  fullWidth = IMAGE_SIZE + (IMAGE_MARGIN * 2)
  Math.floor(viewportWidth.get() / fullWidth)

Template.releases.helpers
  rows: ->
    albumsPerRow = calcAlbumsPerRow()

    Object.keys(BOB).reduce (rows, key, index) ->
      rows.push [] if index % albumsPerRow is 0
      rows[rows.length - 1].push id: key, file: BOB[key]
      rows
    ,
      []

Template.column.helpers
  IMAGE_MARGIN: ->
    IMAGE_MARGIN

  IMAGE_SIZE: ->
    IMAGE_SIZE

  isCurrent: ->
    Iron.controller().state.get('id') is @id

release = (data, fieldName) ->
  currentAlbum = _.findWhere data, id: Iron.controller().state.get(fieldName)
  return unless currentAlbum
  Releases.get currentAlbum.id

Template.release.helpers
  currentRelease: ->
    release @, 'id'

  previousRelease: ->
    release @, 'oldId'
