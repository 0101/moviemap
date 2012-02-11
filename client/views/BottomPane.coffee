$ = require 'jquery-browserify'
{BaseView} = require './base'


module.exports = class BottomPane extends BaseView

  initialize: ({@window}) ->
    @adjustSize()
    $(@window).resize => @adjustSize()

  adjustSize: ->
    $(@el).height $(@window).height() - $(@el).offset().top

  setMapOnly: -> $(@el).addClass 'map-only'
  unsetMapOnly: -> $(@el).removeClass 'map-only'

