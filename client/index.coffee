$ = require 'jquery-browserify'

# assign jQuery to the window so Backbone can pick it up...
window.jQuery = $

Backbone = require 'backbone-browserify'


{Movie, MovieList} = require './models'
{SearchBar, SearchResults} = require './views'
{Router} = require './routers'

$ ->
  console.log Router

  movieList = new MovieList()

  searchResults = new SearchResults collection: movieList

  router = new Router movieList

  navigateTo = (url) -> router.navigate url, true



  console.log 'document ready'

  searchBar = new SearchBar el: $('#search-bar').get 0
  searchBar.bind 'search', (text) -> navigateTo "search/#{text}"

  router.bind 'all', (args...) -> console.log "Router event: ", args
  router.bind 'route:search', (q) ->
    searchBar.render q
    searchBar.showLoading()
  router.bind 'search:finished', (q) -> searchBar.hideLoading()



  $('body').append searchResults.el

  Backbone.history.start pushState: true


