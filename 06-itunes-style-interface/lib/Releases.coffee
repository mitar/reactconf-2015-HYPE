API = 'https://api.discogs.com/releases'

@Releases = createStore (id) ->
  result = new ReactiveVar null

  HTTP.get "#{API}/#{id}", (error, response) ->
    result.set response.data

  result
