Router.route '/',
  name: 'index'
  template: 'index'

Router.route '/album/:id',
  name: 'album'
  template: 'albums'

  action: ->
    Tracker.nonreactive =>
      @state.set 'oldId', @state.get 'id'
    @state.set 'id', @params.id if Releases.get(@params.id) and Colors.get(@params.id)
    @render()
