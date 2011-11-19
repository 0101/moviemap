Backbone = require 'backbone-browserify'

API = require './api'


class Router extends Backbone.Router

  initialize: (@movieList) ->

  routes:
    'search/:query': 'search'
    'movie/:id': 'movieDetail'

  search: (string) ->
    console.log 'Router.search ', string
    console.log @movieList
    query = title: string
    API.search query, (response) =>
      console.log "inside API.search handle response"
      @movieList.reset response
      @trigger 'search:finished', string

  movieDetail: (id) ->
    console.log 'Router.movieDetail ', id


module.exports = {Router}
