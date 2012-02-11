{BaseView} = require './base'


module.exports = class Map extends BaseView

  initialZoom: 3

  initialPosition: new google.maps.LatLng 30, 30

  initialize: ->
    @points = []
    @bounds = new google.maps.LatLngBounds
    @locRefs = {}

  render: ->
    @map = new google.maps.Map @$('.map-container').get(0),
      mapTypeId: google.maps.MapTypeId.ROADMAP
      zoom: @initialZoom
      center: @initialPosition

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

  resize: -> google.maps.event.trigger @map, 'resize'

  reset: ->
    @clear()
    @resize()
    @map.setCenter @initialPosition
    @map.setZoom @initialZoom

