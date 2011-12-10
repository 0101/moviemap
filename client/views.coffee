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
    @collection.bind 'reset', => @render()
    # TODO: results as extra views...
    @collection.bind 'change:imageUrl', (movie, imageUrl) =>
      console.log "change:imageUrl:::: ", movie, imageUrl, ".movie-#{movie.get '_id'} .image"
      @$(".movie-#{movie.get '_id'} .image").append $ '<span/>',
        class: 'poster', style: "background-image:url(#{imageUrl})"

    @collection.bind 'all', (args...) -> console.log "search results collection event:", args...


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

  events:
    'click li': 'panTo'

  initialize: ({@map}) ->
    console.log "MovieDetail initialize", @model
    @model.bind 'change', => @render()
    @model.bind 'location:geo', (locRef) =>
      @addToMap locRef
      @$("li[data-id='#{locRef._id}']").removeClass('no-geo').addClass('geo')
    @model.bind 'all', (args...) -> console.log "Movie event: ", args...
    @model.bind 'change:_id', => @map.clear()

  fadeOut: -> $(@el).addClass 'fade'
  fadeIn: -> $(@el).removeClass 'fade'

  render: ->
    console.log "rendering MovieDetail"
    $(@el).removeClass 'fade'
    $(@el).html renderFile @template, movie: @model.toJSON()

  addToMap: ({location, description, _id}) ->
    {geo, name} = location
    @map.show()
    @map.addPoint {geo, name, description, _id}

  panTo: ({target}) ->
    id = $(target).closest('li').data('id')
    @map.panTo id




class Map extends Backbone.View

  initialize: ->
    @points = []
    @bounds = new google.maps.LatLngBounds
    @locRefs = {}

  render: ->
    @map = new google.maps.Map @$('.map-container').get(0),
      mapTypeId: google.maps.MapTypeId.ROADMAP
      zoom: 3
      center: new google.maps.LatLng 30, 30

  addPoint: ({geo, name, description, _id}) ->
    google.maps.event.trigger @map, 'resize'
    position = new google.maps.LatLng geo.lat, geo.lng
    @bounds.extend position
    @map.fitBounds @bounds
    marker = new google.maps.Marker
      position: position
      map: @map
      title: description
      animation: google.maps.Animation.DROP
    @points.push marker
    @locRefs[_id] = {marker, position}

  clear: ->
    @points.map (marker) -> marker.setMap null
    @points = []
    @locRefs = {}
    @bounds = new google.maps.LatLngBounds

  hide: -> @$('.overlay').show()
  show: -> @$('.overlay').hide()
  showIfNotEmpty: -> if @points.length then @show()

  panTo: (_id) ->
    console.log "panTo", _id, "current zoom:", @map.getZoom()
    if @locRefs[_id]?
      {marker, position} = @locRefs[_id]
      @map.panTo position
      if @map.getZoom() < 12 then @map.setZoom 13
      if @map.getZoom() > 18 then @map.setZoom 16
      marker.setAnimation google.maps.Animation.BOUNCE
      setTimeout (-> marker.setAnimation null), (3 * 750)










class BottomPane extends Backbone.View

  initialize: ({@window}) ->
    @adjustSize()
    $(@window).resize => @adjustSize()

  adjustSize: ->
    $(@el).height $(@window).height() - $(@el).offset().top


  setMapOnly: -> $(@el).addClass 'map-only'
  unsetMapOnly: -> $(@el).removeClass 'map-only'



module.exports = {SearchBar, SearchResults, MovieDetail, Map, BottomPane}
