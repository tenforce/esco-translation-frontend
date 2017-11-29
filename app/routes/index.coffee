`import Ember from 'ember'`
`import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin'`

IndexRoute = Ember.Route.extend AuthenticatedRouteMixin,
  session: Ember.inject.service('session')
  config: Ember.inject.service()
  afterModel: (transition) ->
    @_super(arguments...)
    @transitionTo('concepts', @get('config.settings.occupationScheme'))

`export default IndexRoute`
