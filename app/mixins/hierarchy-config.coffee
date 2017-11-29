`import Ember from 'ember'`
`import {sortByPromise} from 'ember-esco-plugins'`
`import ENV from '../config/environment'`

HierarchyConfigMixin = Ember.Mixin.create
  currentUser: Ember.inject.service()
  user: Ember.computed.alias 'currentUser.user'
  statuses: ENV.statuses
  disableTaxonomyChange: ENV.translation.disableTaxonomyChange
  selectTaxonomyTitle: ENV.translation.tooltipTaxonomyChange
  displayLanguage: Ember.computed "user.language", "user.showIscoInChosenLanguage", ->
    if @get('user.showIscoInChosenLanguage') == "yes"
      @get('user.language') or "en"
    else
      "en"
  language: Ember.computed.oneWay 'user.language'
  poetry: Ember.computed.alias "user.poetryTask.id"
  status: 'all'

  ###
  # Builds a filter object that is compatible with the taxonomy-browser's filter requirements
  ###
  filters: Ember.computed 'poetry', 'language', ->
    filterConfig = ENV.filters
    poetry = @get 'poetry'
    status = @get 'status'

    if status == 'all'
      status = null

    config = null
    if poetry
      config = filterConfig.withPoetry
    else
      config = filterConfig.withoutPoetry
    @_computeFilters(config)

  # based on the given config, compute the right filter spec
  _computeFilters: (config) ->
    statuses = @get 'statuses'
    self = this
    filters = statuses.map (status) ->
      currentConfig = config
      # all is a special one, we need a different filter for it or none if also not filtering
      # on poetry
      if status.id == 'all'
        if config.variables.indexOf('poetry') >= 0
          currentConfig = ENV.filters?.withPoetryNoStatus
        else
          currentConfig = {}
      filter =
        name: status.name
        id: currentConfig.id
        params: {}
      currentConfig.variables?.map (name) ->
        filter.params[name] = self.get name
      filter.params.status = status.id
      filter

  config: Ember.computed 'defaultExpanded', 'displayLanguage', ->
    # if display language changes, fetch the concepts again
    @get 'displayLanguage'
    # property path to the property that should be used as label
    # e.g. model.label.en would be label.en
    Ember.Object.create
      sortBy: ["defaultCode", "defaultPrefLabel"]
      labelPropertyPath: 'displayPrefLabel'
      onActivate: (node) =>
        @send 'activateItem', node

      # max amount (n) of children to be shown before a load more button is presented
      # load more button shows an extra n children
      showMaxChildren: 50
      noScroll: true
      # route used in link-to of the node
      linkToRoute: 'concepts.show'
      afterComponent: 'concept-status'
      beforeComponent: 'concept-notation'
      included: []

`export default HierarchyConfigMixin`
