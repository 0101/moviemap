_ = require 'underscore'
Backbone = require 'backbone-browserify'

API = require './api'


class Movie extends Backbone.Model

  initialize: ->
    @bind 'change:episodes', ->
      @get('episodes').sort (a, b) -> (a.number or 0) - (b.number or 0)

    @bind 'change:locations', (m, locations) =>
      locations.map (locRef) =>
        {location, description} = locRef
        if location.geo
          @trigger 'location:geo', locRef
        else if not location.fullGeoResults
          API.getGeo location._id, (newLocation) =>
            console.log "API.getGeo response:", newLocation
            locRef.location = newLocation
            if newLocation.geo
              console.log @, "triggering", locRef
              @trigger 'location:geo', locRef
            else
              console.log "no geo,hmmmmm", newLocation

  toJSON: -> _.extend super(), url: @url()

  url: -> "/movie/#{@get 'fullTitle'}"


class MovieList extends Backbone.Collection

  model: Movie

  initialize: ->
    @bind 'reset', =>
      @map (movie) =>
        if not movie.get 'imageUrl'
          API.getImdbData movie.get('_id'), (data) =>
            movie.set imageUrl: data.imageUrl
            console.log movie



module.exports = {Movie, MovieList}
