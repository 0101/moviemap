$ = require 'jquery-browserify'
{BaseView} = require './base'


module.exports = class MovieDetail extends BaseView

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
    $(@el).removeClass 'fade'
    super movie: @model.toJSON()

  addToMap: ({location, description, _id}) ->
    {geo, name} = location
    @map.show()
    @map.addPoint {geo, name, description, _id}

  panTo: ({target}) ->
    id = $(target).closest('li').data('id')
    @map.panTo id



