$ = require 'jquery-browserify'
Backbone = require 'backbone-browserify'
{renderFile} = require 'browserijade'


class SearchBar extends Backbone.View

  template: 'search-bar'

  events:
    'keydown input': 'search'

  render: (value='') ->
    hadFocus = @$('input').is ':focus'
    $(@el).html renderFile @template, {value}
    if hadFocus
      # reset focus and move cursor to the end
      @$('input').focus().val('').val(value)

  search: ({keyCode}) ->
    value = $.trim @$('input').val()
    if keyCode is 13 and value isnt ''
      @trigger 'search', value

  showLoading: -> $(@el).addClass 'loading'
  hideLoading: -> $(@el).removeClass 'loading'


class SearchResults extends Backbone.View

  template: 'search-results'

  events:
    'click li': 'select'

  initialize: ->
    @collection.bind 'all', => @render()

  render: ->
    $(@el).html renderFile @template, movies: @collection.toJSON()

  select: (event) ->
    event.preventDefault()
    console.log 'SearchResults->select ', event.target


module.exports = {SearchBar, SearchResults}
