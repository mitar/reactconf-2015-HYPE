isOld = (data) ->
  oldId = Iron.controller().state.get('oldId')
  # Release API result id is a number, so we have to stringify
  # it because we are using string IDs everywhere else.
  oldId is "#{ data.id }"

Template.album.created = ->
  if isOld @data
    # Set the height of the tracklist initially to the "auto"
    # so that we can animate it shrinking.
    @_height = new ReactiveVar 'auto'
  else
    # Set the height of the tracklist initially to the "0"
    # so that we can animate it growing.
    @_height = new ReactiveVar '0px'

Template.album.rendered = ->
  if isOld @data
    # After the tracklist has been added to the DOM, set fixed height.
    @_height.set "#{ @$('.container').outerHeight() }px"

    # And then shrink it.
    Meteor.defer =>
      @_height.set '0px'

  else
    @autorun (computation) =>
      # Registers a data context dependency.
      Template.currentData()
      Tracker.afterFlush =>
        # After the tracklist has been updated in the DOM,
        # resize it to the new height with animation.
        @_height.set "#{ @$('.container').outerHeight() }px"

Template.album.helpers
  fg: ->
    Colors.get(@id)?.fg

  bg: ->
    Colors.get(@id)?.bg

  height: ->
    Template.instance()._height.get()
