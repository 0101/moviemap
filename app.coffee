express = require 'express'
browserify = require 'browserify'
{browserijade} = require 'browserijade'

settings = require './settings'


browserifyFor = (env) ->
  bundle = browserify
    require: ['./client/index']
    filter: if env is 'production' then require 'uglify-js' else null
  bundle.use browserijade "#{__dirname}/templates/includes"
  return bundle


app = express.createServer()


app.configure ->
  app.use app.router
  app.use express.logger format: 'dev'
  app.use express.bodyParser()
  app.use express.static "#{__dirname}/static", maxAge: 24*60*60*1000

  app.set 'views', "#{__dirname}/templates"
  app.set 'view engine', 'jade'
  app.set 'view options', layout: false

app.configure 'production', ->
  app.use express.errorHandler stack: false
  app.use browserifyFor 'production'

app.configure 'development', ->
  app.use express.errorHandler stack: true
  app.use browserifyFor 'development'


index = (request, response) -> response.render 'index', value: ''

app.get '/', index
app.get '/search/*', index
app.get '/movie/*', index


app.listen settings.port

console.log "running on port #{settings.port}"
