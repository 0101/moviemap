_ = require 'underscore'
Backbone = require 'backbone-browserify'


class Movie extends Backbone.Model

  initialize: -> @id = @get 'fullTitle'

  toJSON: -> _.extend super(), url: @url()


class MovieList extends Backbone.Collection

  model: Movie

  url: '/movie'


module.exports = {Movie, MovieList}
