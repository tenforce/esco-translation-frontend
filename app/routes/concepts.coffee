`import Ember from 'ember'`
`import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin'`
`import EnsureLanguageSetMixin from '../mixins/ensure-language-set'`

ConceptsRoute = Ember.Route.extend AuthenticatedRouteMixin, EnsureLanguageSetMixin,
  config: Ember.inject.service()
  model: (params) ->
    options = {}
    @store.findOneQuery('taxonomy', params.taxonomy, options).then (taxonomy) =>
      @set 'config.taxonomy', taxonomy
      taxonomy

`export default ConceptsRoute`
