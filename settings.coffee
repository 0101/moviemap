_ = require 'underscore'


# base settings
base =

  env: process.env.NODE_ENV or 'development'

  port: 4002


# overrides for individual environments
overrides = {}

module.exports = _.extend base, overrides[base.env] or {}


