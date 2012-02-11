$ = require 'jquery-browserify'
{BaseView} = require './base'


module.exports = class IntroBox extends BaseView

  hide: -> $(@el).hide()

