$ = require 'jquery-browserify'
# assign jQuery to the window so Backbone can pick it up...
window.jQuery = $
require './jquery.mousewheel'
Backbone = require 'backbone-browserify'

{Movie, MovieList} = require './models'
{SearchBar, SearchResults, MovieDetail, Map, BottomPane} = require './views'
{Router} = require './routers'





movieList = new MovieList()
selectedMovie = new Movie()

searchResults = new SearchResults collection: movieList

router = new Router movieList, selectedMovie
router.bind 'all', (args...) ->
  console.log "Router event: ", args
  #$('body').addClass 'minimized'

navigateTo = (url) -> router.navigate url, true


switchToMinLayout = -> $('body').addClass 'minimized'


$(document).ready ->
  console.log 'DOM ready'

  searchBar = new SearchBar el: $('#search-bar').get 0
  searchBar.bind 'search', (text) -> navigateTo "search/#{text}"

  router.bind 'route:search', (q) ->
    searchBar.render q
    searchBar.showLoading()
  router.bind 'search:finished', (q) ->
    searchBar.hideLoading()
    movieDetail.fadeOut()
    map.hide()
    switchToMinLayout()
    $(window).resize()

  router.bind 'route:movieDetail', ->
    movieDetail.fadeIn()
    map.showIfNotEmpty()
    bottomPane.unsetMapOnly()

  searchBar.focus()

  $('.search-results-pane').append searchResults.el
  searchResults.bind 'select', (url) -> navigateTo url.replace /^\//, ''

  bottomPane = new BottomPane el: $('.bottom-pane'), window: window
  bottomPane.setMapOnly()

  map = new Map el: $('.map-pane')
  map.render()
  map.hide()

  movieDetail = new MovieDetail model: selectedMovie, map: map
  $('.movie-detail-pane').append movieDetail.el


  Backbone.history.start pushState: true


