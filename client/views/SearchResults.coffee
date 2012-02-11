$ = require 'jquery-browserify'
{BaseView} = require './base'


module.exports = class SearchResults extends BaseView

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
    super movies: @collection.toJSON()
    itemWidth = @$('a').width()
    @$('ol').width @collection.size() * itemWidth
    @selected = null

  select: (event) ->
    event.preventDefault()
    @selected?.removeClass 'selected'
    @selected = $(event.target).closest 'a'
    @trigger 'select', @selected.attr 'href'
    @selected.addClass 'selected'

  scroll: (e, dir) ->
    dx = if dir is 1 then '-=450' else '+=450'
    $(@el).stop().animate {scrollLeft: dx}, 300
    e.preventDefault()




