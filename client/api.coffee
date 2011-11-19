$ = require 'jquery-browserify'
settings = require './settings'

apiGet = (action, data, callback) ->
  url = settings.apiRoot + action
  $.get url, data, callback, 'JSON'

module.exports =
  search: (query, callback) ->
    console.log "API search"
    apiGet 'search', query, callback
