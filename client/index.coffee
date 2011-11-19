$ = require 'jquery-browserify'
# assign jQuery to the window so Backbone can pick it up...
window.jQuery = $
Backbone = require 'backbone-browserify'

{Movie, MovieList} = require './models'
{SearchBar, SearchResults, MovieDetail} = require './views'
{Router} = require './routers'


movieList = new MovieList()
selectedMovie = new Movie()

searchResults = new SearchResults collection: movieList
movieDetail = new MovieDetail model: selectedMovie

router = new Router movieList, selectedMovie
router.bind 'all', (args...) -> console.log "Router event: ", args

navigateTo = (url) -> router.navigate url, true


$(document).ready ->
  console.log 'document ready'

  searchBar = new SearchBar el: $('#search-bar').get 0
  searchBar.bind 'search', (text) -> navigateTo "search/#{text}"

  router.bind 'route:search', (q) ->
    searchBar.render q
    searchBar.showLoading()
  router.bind 'search:finished', (q) ->
    searchBar.hideLoading()
    movieDetail.fadeOut()

  router.bind 'route:movieDetail', ->
    movieDetail.fadeIn()

  searchBar.focus()

  $('body').append searchResults.el
  searchResults.bind 'select', (url) -> navigateTo url.replace /^\//, ''

  $('body').append movieDetail.el

  Backbone.history.start pushState: true


