Router.route '/',
  name: 'index'
  template: 'index'

Router.route '/album/:id',
  name: 'album'
  template: 'albums'

  action: ->
    @state.set 'id', @params.id if Releases.get(@params.id) and Colors.get(@params.id)
    @render()
