$ = require 'jquery-browserify'
# assign jQuery to the window so Backbone can pick it up...
window.jQuery = $
require './jquery.mousewheel'
Backbone = require 'backbone-browserify'

{Movie, MovieList} = require './models'
{Router} = require './routers'
API = require './api'

SearchBar = require './views/SearchBar'
SearchResults = require './views/SearchResults'
MovieDetail = require './views/MovieDetail'
Map = require './views/Map'
BottomPane = require './views/BottomPane'
IntroBox = require './views/IntroBox'


movieList = new MovieList()
examples = new MovieList()
selectedMovie = new Movie()

searchResults = new SearchResults collection: movieList

router = new Router movieList, selectedMovie

navigateTo = (url) -> router.navigate url, true


switchToMinLayout = ->
  $('body').addClass 'minimized'
  $(window).resize()


$(document).ready ->
  console.log 'DOM ready'
  $('.logo a').click (event) ->
    event.preventDefault()
    navigateTo ''


  searchBar = new SearchBar el: $('#search-bar').get 0
  searchBar.bind 'search', (text) -> navigateTo "search/#{text}"

  router.bind 'all', (route, args...) ->
    console.log "Router event: ", route, args
    if route isnt 'route:home'
      introBox.hide()

  router.bind 'route:home', ->
    searchResults.hide()
    map.hide()
    bottomPane.setMapOnly()
    map.clear()
    map.resize()
    introBox.show()
    API.getExamples (response) -> examples.reset response
    $('body').removeClass 'minimized'
    $(window).resize()

  router.bind 'route:search', (q) ->
    searchBar.render q
    searchBar.showLoading()

  router.bind 'search:finished', (q) ->
    searchResults.show()
    searchBar.hideLoading()
    map.hide()
    switchToMinLayout()
    bottomPane.setMapOnly()
    map.clear()
    map.resize()

  router.bind 'route:movieDetail', ->
    movieDetail.fadeIn()
    map.showIfNotEmpty()
    bottomPane.unsetMapOnly()
    switchToMinLayout()
    searchBar.blur()

  searchBar.focus()

  introBox = new IntroBox el: $('.intro-box'), collection: examples

  $('.search-results-pane').append searchResults.el
  searchResults.bind 'select', (url) -> navigateTo url.replace /^\//, ''
  introBox.bind 'select', (url) ->
    console.log 'introbox select:', url
    navigateTo url.replace /^\//, ''

  bottomPane = new BottomPane el: $('.bottom-pane'), window: window
  bottomPane.setMapOnly()

  map = new Map el: $('.map-pane')
  map.render()
  map.hide()

  movieDetail = new MovieDetail model: selectedMovie, map: map
  $('.movie-detail-pane').append movieDetail.el

  Backbone.history.start pushState: true


