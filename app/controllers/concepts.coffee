`import Ember from 'ember'`
`import HierarchyConfig from '../mixins/hierarchy-config'`

ConceptsController = Ember.Controller.extend HierarchyConfig,
  currentUser: Ember.inject.service()
  disableShortcuts: Ember.computed.alias 'currentUser.disableShortcuts'
  conf: Ember.inject.service('config')
  activateItem: (item) ->
    @transitionToRoute('concepts.show', item.get('id'))
  taxonomies: Ember.computed 'conf.settings', ->
    [
      {
        label: "Occupations",
        id: @get('conf.settings.occupationScheme')
      },
      {
        label: "Skills",
        id: @get('conf.settings.skillScheme')
      }
    ]
  selectedTaxonomy: Ember.computed 'taxonomies', 'model.id', ->
    id = @get 'model.id'
    @get('taxonomies').filterBy("id", id )[0]
  actions:
    selectTaxonomy: (taxonomy) ->
      @transitionToRoute('concepts', taxonomy.id)
    activateItem: (item) ->
      @activateItem(item)
    toggleDisplayInChosenLanguage: ->
      #@toggleBooleanProp 'user.showIscoInChosenLanguage'
      if @get('user.showIscoInChosenLanguage') is 'yes'
        @set('user.showIscoInChosenLanguage', 'no')
      else if @get('user.showIscoInChosenLanguage') is 'no'
        @set('user.showIscoInChosenLanguage', 'yes')
      else if @get('user.showIscoInChosenLanguage') is undefined
        @set('user.showIscoInChosenLanguage', 'yes')


`export default ConceptsController`
