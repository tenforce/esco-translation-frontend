`import Ember from 'ember'`

GobblerRoute = Ember.Route.extend
  config: Ember.inject.service()
  redirect: ->
    @transitionTo('concepts', @get('config.settings.occupationScheme'));

`export default GobblerRoute`
