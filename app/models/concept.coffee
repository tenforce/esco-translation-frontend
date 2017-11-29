`import DS from 'ember-data'`
`import env from '../config/environment'`
`import ESCO from 'ember-esco-concept-description'`

defaultLang = env.translation.defaultLanguage
Concept = DS.Model.extend ESCO.Concept,
  readOnlyAttributes: ['description', 'types', 'codes', 'skill-type']
  readOnlyRelationships: ['broader', 'narrower', 'relations', 'inverse-relations', 'tasks', 'pref-labels', 'alt-labels', 'hidden-labels']

  taxonomy: DS.hasMany('taxonomy', inverse:null)
  taxonomies: Ember.computed.alias 'taxonomy'

  currentUser: Ember.inject.service()
  user: Ember.computed.alias 'currentUser.user'
  lastModifier: DS.belongsTo('user', inverse: null, async: false )
  lastModified: DS.attr('string')
  save: () ->
    if not @get('isDeleted')
      @set('lastModifier', @get('user'))
      @set('lastModified', (new Date()).toISOString())
    @_super(arguments...)


  types: DS.attr('string-set')
  codes: DS.attr('string-set')
  code: null
  escoNote: DS.attr('string')
  prefLabels: DS.hasMany('concept-label', inverse: null)
  altLabels: DS.hasMany('concept-label', inverse: null)
  hiddenLabels: DS.hasMany('concept-label', inverse: null)
  defaultCode: Ember.computed 'codes', ->
    filtered = @get('codes')?.filter (code) ->
      if (code.search 'CTC') is -1
        return true
      else return false
    if filtered
      filtered[0]
    else
      ""

  languagePreference: Ember.computed 'currentUser.language', 'user.showIscoInChosenLanguage', ->
    @get('user.showIscoInChosenLanguage')
    @get('currentUser.language')
    array = []
    if @get('user.showIscoInChosenLanguage') is 'yes'
      array.push @get('currentUser.language')
    array.push 'en'
    return array
  displayLanguage: Ember.computed 'currentUser.language', 'user.showIscoInChosenLanguage', ->
    if @get('user.showIscoInChosenLanguage') is 'yes'
      return @get('currentUser.language')
    return 'en'
  language: Ember.computed.alias 'currentUser.language'


  # breadcrumb: Ember.computed 'broader', ->
  #   # getBroader = (node, promises) ->
  #   #   broad = node.get('broader', promises)
  #   #   broad.then (result) ->
  #   #     unless result
  #   #       Ember.RSVP.Promise.all(promises).then (results) ->
  #   #         results.join(">")
  #   #     else
  #   #       promises.push(result.get('defaultPrefLabel'))
  #   #       getBroader(result, promises)
  #   #
  #   # getBroader(this,[])
  #   #  broad = node.get('broader', promises)
  #   #  broad.then (result) ->
  #   #    unless result
  #   #      Ember.RSVP.Promise.all(promises).then (results) ->
  #   #        results.join(">")
  #   #    else
  #   #      promises.push(result.get('defaultPrefLabel')
  #   #      getBroader(result, promises)
  #
  #   @get('broader').then (broader) ->
  #     promises = []
  #
  #     broader.forEach (concept) ->
  #       promises.push(concept.get('defaultPrefLabel'))
  #
  #     Ember.RSVP.Promise.all(promises).then (results) ->
  #       labels = ""
  #       results.forEach (label) ->
  #         unless labels
  #           labels = label
  #         else
  #           labels = labels + " / " + label
  #         console.log labels
  #       return labels

  #languagePreference: ["fr", "en"]
  tasks: DS.hasMany('task', inverse: null)
  ###
  hasTasks used to be computed on "tasks.length" but as the expanding tree needs to fetch the tasks in order to display an icon for the status,
  hasTasks would be called again, messing the concept-translation component (it would be initialized twice and make a lot of useless calls)
  ###
  hasTasks: Ember.computed ->
    @get('tasks').then (tasks) ->
      if tasks && Ember.get(tasks,'length') > 0
        return true
      else
        return false
  anyChildren: true
  hasChildren: Ember.computed "anyChildren", ->
    return @get('anyChildren')

  # TODO : We should have a language set in the model, all properties should then try to get values according to that language.
  # TODO : To do so, we should have a function to get the value of a property according to a language.
  preflabel: Ember.computed 'prefLabels', 'languagePreference', ->
    langs = @get 'languagePreference'
    @get('prefLabels').then (labels) ->
      best = null
      langs.map (lang) ->
        best ||= labels.filterBy('language', lang)?[0]?.get('literalForm')
      best || labels.objectAt(0)?.get('literalForm')
  prefdescription: Ember.computed 'description.@each', 'languagePreference', ->
    langs = @get 'languagePreference'
    descriptions = @get('description')
    best = null
    langs.map (lang) =>
      best ||= descriptions.filterBy('language', lang)?[0]?.get('content')
    best || labels.objectAt(0)?.get('content')

  msgNoTranslatedPrefLabel: Ember.computed 'defaultPrefLabel', 'displayLanguage', ->
    if @get('displayLanguage') is "en"
      new Ember.RSVP.Promise ->
        return "No preferred term"
    else
      @get('defaultPrefLabel').then (label) ->
        return "#{label} (translation pending)"
  displayPrefLabel: Ember.computed 'displayLanguage', 'displayPrefLabels.firstObject.literalForm', ->
    @get('displayPrefLabels')?.then (labels) =>
      lit = labels.get('firstObject.literalForm')
      # NB : Looks like we have to display that no translation has been provided for this guy
      #unless lit then return @get('defaultPrefLabel')
      unless lit then return @get('msgNoTranslatedPrefLabel')
      else lit
  displayPrefLabels: Ember.computed 'displayLanguage', 'prefLabels', ->
    @get('prefLabels')?.then (labels) =>
      res = Ember.ArrayProxy.create content: labels?.filterBy('language', @get('displayLanguage'))
      return res.sortBy('literalForm')

  localizedPrefLabels: Ember.computed 'prefLabels', 'language', ->
    @get('prefLabels')?.then (labels) =>
      res = Ember.ArrayProxy.create content: labels?.filterBy('language', @get('language'))
      return res.sortBy('literalForm')
  localizedAltLabels: Ember.computed 'altLabels', 'language', ->
    @get('altLabels')?.then (labels) =>
      res = Ember.ArrayProxy.create content: labels?.filterBy('language', @get('language'))
      return res.sortBy('literalForm')
  localizedHiddenLabels:Ember.computed 'hiddenLabels', 'language', ->
    @get('hiddenLabels')?.then (labels) =>
      res = Ember.ArrayProxy.create content: labels?.filterBy('language', @get('language'))
      return res.sortBy('literalForm')
`export default Concept`
