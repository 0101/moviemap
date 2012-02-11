$ = require 'jquery-browserify'
{BaseView} = require './base'


module.exports = class IntroBox extends BaseView

  events:
    'click li a': 'select'

  initialize: ->
    console.log "Intro box collection:", @collection
    @collection.bind 'reset', => @render()

  hide: -> $(@el).hide()

  show: -> $(@el).show()

  render: ->
    console.log "Rendering intro box"
    super examples: @collection.toJSON()

  select: (event) ->
    event.preventDefault()
    @trigger 'select', $(event.target).closest('a').attr 'href'
