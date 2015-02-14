Router.route '/',
  name: 'index'
  template: 'index'

Router.route '/album/:id',
  name: 'album'
  template: 'albums'
