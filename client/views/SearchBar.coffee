$ = require 'jquery-browserify'
{BaseView} = require './base'


module.exports = class SearchBar extends BaseView

  events:
    'keydown input': 'search'
    'focus input': 'setFocused'
    'blur input': 'unsetFocused'

  focus: ->
    # focus and move cursor to the end of the input
    value = @$('input').val()
    @$('input').focus().val('').val(value)

  blur: -> @$('input').blur()

  setFocused: -> $(@el).addClass 'focused'

  unsetFocused: -> $(@el).removeClass 'focused'

  render: (value='') ->
    hadFocus = @$('input').is ':focus'
    super {value}
    if hadFocus then @focus()

  search: ({keyCode}) ->
    value = $.trim @$('input').val()
    if keyCode is 13 and value isnt ''
      @trigger 'search', value

  showLoading: -> $(@el).addClass 'loading'
  hideLoading: -> $(@el).removeClass 'loading'

