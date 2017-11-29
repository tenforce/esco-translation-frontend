`import Ember from 'ember';`
`import config from './config/environment';`

Router = Ember.Router.extend
  location: config.locationType

unless config.baseURL == "/"
  Ember.$.ajaxSetup
    beforeSend: (xhr, options) ->
      options.url = config.baseURL + options.url;

Router.map ->
  @route 'concepts', { path: 'concepts/:taxonomy' }, ->
    @route 'show', { path: ':id' }
  @route 'sign-in'
  @route 'admin', ->
    @route 'index'
    @route 'import'
  @route 'notifications'
  @route 'profile'
  @route 'validation'
  @route 'set-language'
  @route 'gobbler', { path: '/*wildcard' }
  @route 'export'
  @route 'xml-import'

`export default Router;`
