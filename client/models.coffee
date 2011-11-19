_ = require 'underscore'
Backbone = require 'backbone-browserify'


class Movie extends Backbone.Model

  initialize: ->
    @bind 'change:episodes', ->
      @get('episodes').sort (a, b) -> (a.number or 0) - (b.number or 0)

  toJSON: -> _.extend super(), url: @url()

  url: -> "/movie/#{@get 'fullTitle'}"


class MovieList extends Backbone.Collection

  model: Movie



module.exports = {Movie, MovieList}
