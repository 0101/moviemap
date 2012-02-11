Backbone = require 'backbone-browserify'

API = require './api'


class Router extends Backbone.Router

  initialize: (@movieList, @selectedMovie) ->

  routes:
    '': 'home'
    'search/:query': 'search'
    'movie/:id': 'movieDetail'

  home: ->
    console.log 'home sweet home'

  search: (string) ->
    # TODO: first filter current results...
    console.log 'Router.search ', string
    console.log @movieList
    query = title: string
    API.search query, (response) =>
      console.log "inside API.search handle response"
      @movieList.reset response
      @trigger 'search:finished', string

  movieDetail: (fullTitle) ->
    console.log 'Router.movieDetail ', fullTitle
    API.getByFullTitle fullTitle, (response) =>
      console.log "getByFullTitle response", response
      console.log "selectedMovie:", @selectedMovie
      @selectedMovie.clear silent:true
      @selectedMovie.set response


module.exports = {Router}
