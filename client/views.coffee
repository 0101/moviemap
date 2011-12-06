$ = require 'jquery-browserify'
Backbone = require 'backbone-browserify'
{renderFile} = require 'browserijade'
settings = require './settings'


class SearchBar extends Backbone.View

  template: 'search-bar'

  events:
    'keydown input': 'search'
    'focus input': 'setFocused'
    'blur input': 'unsetFocused'

  focus: ->
    # focus and move cursor to the end of the input
    value = @$('input').val()
    @$('input').focus().val('').val(value)

  setFocused: -> $(@el).addClass 'focused'

  unsetFocused: -> $(@el).removeClass 'focused'

  render: (value='') ->
    hadFocus = @$('input').is ':focus'
    $(@el).html renderFile @template, {value}
    if hadFocus then @focus()

  search: ({keyCode}) ->
    value = $.trim @$('input').val()
    if keyCode is 13 and value isnt ''
      @trigger 'search', value

  showLoading: -> $(@el).addClass 'loading'
  hideLoading: -> $(@el).removeClass 'loading'


class SearchResults extends Backbone.View

  template: 'search-results'

  className: 'SearchResults'

  events:
    'click li a': 'select'
    'mousewheel': 'scroll'

  initialize: ->
    @collection.bind 'all', => @render()

  render: ->
    $(@el).html renderFile @template, movies: @collection.toJSON()
    itemWidth = @$('a').width()
    @$('ol').width @collection.size() * itemWidth

  select: (event) ->
    event.preventDefault()
    @trigger 'select', $(event.target).closest('a').attr 'href'

  scroll: (e, dir) ->
    dx = if dir is 1 then '-=450' else '+=450'
    $(@el).stop().animate {scrollLeft: dx}, 300
    e.preventDefault()


class MovieDetail extends Backbone.View

  template: 'movie-detail'

  className: 'MovieDetail'

  initialize: ({@map}) ->
    console.log "MovieDetail initialize", @model
    @model.bind 'change', => @render()
    @model.bind 'location:geo', (locRef) => @addToMap locRef
    @model.bind 'all', (args...) -> console.log "Movie event: ", args...

  fadeOut: -> $(@el).addClass 'fade'
  fadeIn: -> $(@el).removeClass 'fade'

  render: ->
    console.log "rendering MovieDetail"
    $(@el).removeClass 'fade'
    $(@el).html renderFile @template, @model.toJSON()

  addToMap: ({location, description}) ->
    {geo, name} = location
    @map.show()
    @map.addPoint {geo, name, description}


class Map extends Backbone.View

  initialize: ->
    @points = []

  render: ->
    console.log "window:", window, "google:", google
    @map = new google.maps.Map @$('.map-container').get(0),
      mapTypeId: google.maps.MapTypeId.ROADMAP
      zoom: 3
      center: new google.maps.LatLng 30, 30

  addPoint: ({geo, name, description}) ->
    marker = new google.maps.Marker
      position: new google.maps.LatLng geo.lat, geo.lng
      map: @map
      title: description
      animation: google.maps.Animation.DROP
    @points.push marker

  clear: ->
    @points.map (marker) -> marker.setMap null
    @points = []

  hide: -> @$('.overlay').show()
  show: -> @$('.overlay').hide()


class BottomPane extends Backbone.View

  initialize: ({@window}) ->
    @adjustSize()
    $(@window).resize => @adjustSize()

  adjustSize: -> $(@el).height $(@window).height() - $(@el).offset().top

  setMapOnly: -> $(@el).addClass 'map-only'
  unsetMapOnly: -> $(@el).removeClass 'map-only'



module.exports = {SearchBar, SearchResults, MovieDetail, Map, BottomPane}
