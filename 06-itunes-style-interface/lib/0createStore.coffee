@createStore = (loadFn) ->
  cache = {}

  get: (id) ->
    return null unless id

    cache[id] = loadFn id unless cache[id]
    cache[id].get()
