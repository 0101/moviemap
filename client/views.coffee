$ = require 'jquery-browserify'
Backbone = require 'backbone-browserify'
{renderFile} = require 'browserijade'


class SearchBar extends Backbone.View

  template: 'search-bar'

  events:
    'keydown input': 'search'

  focus: ->
    # focus and move cursor to the end of the input
    value = @$('input').val()
    @$('input').focus().val('').val(value)

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

  events:
    'click li a': 'select'

  initialize: ->
    @collection.bind 'all', => @render()

  render: ->
    $(@el).html renderFile @template, movies: @collection.toJSON()

  select: (event) ->
    event.preventDefault()
    @trigger 'select', $(event.target).attr 'href'


class MovieDetail extends Backbone.View

  template: 'movie-detail'

  initialize: ->
    console.log "MovieDetail initialize", @model
    @model.bind 'change', => @render()

  fadeOut: -> $(@el).addClass 'fade'
  fadeIn: -> $(@el).removeClass 'fade'

  render: ->
    $(@el).removeClass 'fade'
    $(@el).html renderFile @template, @model.toJSON()


module.exports = {SearchBar, SearchResults, MovieDetail}
