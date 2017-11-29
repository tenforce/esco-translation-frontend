`import Ember from 'ember'`
`import UserRights from '../mixins/user-rights'`
`import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin'`
`import EnsureLanguageSetMixin from '../mixins/ensure-language-set'`

NotificationsRoute = Ember.Route.extend AuthenticatedRouteMixin, EnsureLanguageSetMixin, UserRights,
  config: Ember.inject.service()

  allowedOnNotifications: Ember.computed 'userIsAdmin', ->
    @get('userIsAdmin')
  allowedOnValidation: Ember.computed 'userIsAdmin', 'userIsReviewer', ->
    @get('userIsAdmin') or @get('userIsReviewer')
  afterModel: (transition) ->
    @_super(arguments...)
    unless @get 'allowedOnNotifications'
      alert('Only administrators can see the notifications.');
      if transition then transition.abort()
      else @transitionTo('concepts', @get('config.settings.occupationScheme'))

`export default NotificationsRoute`
