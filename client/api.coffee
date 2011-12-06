$ = require 'jquery-browserify'
settings = require './settings'

apiGet = (action, data, callback) ->
  url = settings.apiRoot + action
  $.get url, data, callback, 'JSON'

module.exports =
  search: (query, callback) ->
    console.log "API search"
    apiGet 'search', query, callback

  getByFullTitle: (fullTitle, callback) ->
    console.log "API getByFullTitle", fullTitle
    apiGet "movie/#{escape fullTitle}", {}, callback

  getGeo: (locationId, callback) ->
    console.log "API getGeo", locationId
    apiGet "geo/#{escape locationId}", {}, callback

  getImdbData: (movieId, callback) ->
    console.log "API getImdbData", movieId
    apiGet "imdbdata/#{escape movieId}", {}, callback

