$ = require 'jquery-browserify'
Backbone = require 'backbone-browserify'
{renderFile} = require 'browserijade'


class BaseView extends Backbone.View

  render: (context) ->
    className = @className or @constructor.name
    template = @template or className

    $el = $(@el)
    $el.html renderFile template, context
    $el.addClass className

  show: -> $(@el).show()

  hide: -> $(@el).hide()


module.exports = {BaseView}
