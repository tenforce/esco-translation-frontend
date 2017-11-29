`import Ember from 'ember'`
`import ENV from '../config/environment'`
`import {languages} from '../utils/languages'`

ValidationController = Ember.Controller.extend
  queryParams: ['platform']
  platform: 'translation'

  languageOptions: Ember.computed 'languages', ->
    allLanguages = {title: "All", id: "all-languages"}
    languages.sort (a, b) ->
      if a.title < b.title then return -1
      if a.title > b.title then return 1
      return 0
    [allLanguages].concat(languages)

  baseURL: Ember.computed ->
    ENV.baseURL

  timeOut: Ember.computed ->
    ENV.validationTimeOut

  currentUser: Ember.inject.service()
  user: Ember.computed.alias 'currentUser.user'
  defaultLang: Ember.computed 'user','user.language', ->
    @get('user.language')

  defaultLanguage: Ember.computed 'defaultLang', ->
    languages.findBy('id', @get('defaultLang'))

  actions:
    onConceptClick: (validation) ->
      @get('store').find('concept', validation.get('parameterUuid')).then (concept) =>
        if concept.get('isOccupation') then scheme = ENV.translation.occupationScheme
        # Check if switch to skill is disabled !
        else if concept.get('isSkill') then unless ENV.translation.disableTaxonomyChange then scheme = ENV.translation.skillScheme
        if scheme then @transitionToRoute('concepts.show', scheme, validation.get('parameterUuid'))


`export default ValidationController`
