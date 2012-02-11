$ = require 'jquery-browserify'
# assign jQuery to the window so Backbone can pick it up...
window.jQuery = $
require './jquery.mousewheel'
Backbone = require 'backbone-browserify'

{Movie, MovieList} = require './models'
{Router} = require './routers'

SearchBar = require './views/SearchBar'
SearchResults = require './views/SearchResults'
MovieDetail = require './views/MovieDetail'
Map = require './views/Map'
BottomPane = require './views/BottomPane'
IntroBox = require './views/IntroBox'


movieList = new MovieList()
selectedMovie = new Movie()

searchResults = new SearchResults collection: movieList

router = new Router movieList, selectedMovie

navigateTo = (url) -> router.navigate url, true


switchToMinLayout = ->
  $('body').addClass 'minimized'
  $(window).resize()


$(document).ready ->
  console.log 'DOM ready'

  searchBar = new SearchBar el: $('#search-bar').get 0
  searchBar.bind 'search', (text) -> navigateTo "search/#{text}"

  router.bind 'all', (args...) ->
    console.log "Router event: ", args
    introBox.hide()

  router.bind 'route:search', (q) ->
    searchBar.render q
    searchBar.showLoading()
  router.bind 'search:finished', (q) ->
    searchBar.hideLoading()
    # movieDetail.fadeOut()
    map.hide()
    switchToMinLayout()
    bottomPane.setMapOnly()
    # map.reset()
    map.clear()
    map.resize()

  router.bind 'route:movieDetail', ->
    movieDetail.fadeIn()
    map.showIfNotEmpty()
    bottomPane.unsetMapOnly()
    switchToMinLayout()
    searchBar.blur()

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

  introBox = new IntroBox el: $('.intro-box')

  Backbone.history.start pushState: true




