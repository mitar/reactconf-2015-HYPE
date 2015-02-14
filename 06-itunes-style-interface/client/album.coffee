Template.album.created = ->
  @_height = new ReactiveVar 0

  @autorun (computation) =>
    # Registers a data context dependency.
    Template.currentData()
    Tracker.afterFlush =>
      @_height.set @$('.container').outerHeight()

Template.album.helpers
  fg: ->
    Colors.get(@id)?.fg

  bg: ->
    Colors.get(@id)?.bg

  height: ->
    "#{ Template.instance()._height.get() }px"
