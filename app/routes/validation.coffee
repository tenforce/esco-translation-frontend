`import Ember from 'ember'`
`import UserRights from '../mixins/user-rights'`
`import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin'`
`import EnsureLanguageSetMixin from '../mixins/ensure-language-set'`

ValidationRoute = Ember.Route.extend AuthenticatedRouteMixin, EnsureLanguageSetMixin, UserRights,
  config: Ember.inject.service()
  queryParams:
    platform:
      refreshModel: true

  allowedOnNotifications: Ember.computed 'userIsAdmin', ->
    @get('userIsAdmin')
  allowedOnValidation: Ember.computed 'userIsAdmin', 'userIsReviewer', ->
    @get('userIsAdmin') or @get('userIsReviewer')
  afterModel: (transition) ->
    @_super(arguments...)
    unless @get 'allowedOnValidation'
      alert('Only authorized people can see the validations.');
      if transition then transition.abort()
      else @transitionTo('concepts', @get('config.settings.occupationScheme'))

`export default ValidationRoute`
