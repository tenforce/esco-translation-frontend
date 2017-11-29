`import Ember from 'ember'`
`import UnauthenticatedRouteMixin from 'ember-simple-auth/mixins/unauthenticated-route-mixin'`

SignInRoute = Ember.Route.extend UnauthenticatedRouteMixin,
  session: Ember.inject.service('session')
  config: Ember.inject.service()

  model: ->
    @get('session').authenticate('authenticator:ecas').then( =>
      @transitionTo('concepts', @get('config.settings.occupationScheme'))
    )

`export default SignInRoute`
