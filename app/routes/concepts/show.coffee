`import Ember from 'ember'`
`import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin'`
`import EnsureLanguageSetMixin from '../../mixins/ensure-language-set'`
`import KeyboardShortcuts from 'ember-keyboard-shortcuts/mixins/route';`

ConceptsShowRoute = Ember.Route.extend AuthenticatedRouteMixin, EnsureLanguageSetMixin, KeyboardShortcuts,
  currentUser: Ember.inject.service()
  saveAllButton: Ember.inject.service()
  disableShortcuts: Ember.computed.alias 'currentUser.disableShortcuts'
  user: Ember.computed.alias 'currentUser.user'

  keyboardShortcuts: Ember.computed 'disableShortcuts', ->
    if @get('disableShortcuts') then return {}
    else
      {
        # <- statusses #
        'ctrl+alt+1': 'ctrlalt1'
        'ctrl+alt+2': 'ctrlalt2'
        'ctrl+alt+3': 'ctrlalt3'
        'ctrl+alt+4': 'ctrlalt4'
        'ctrl+alt+5': 'ctrlalt5'
        'ctrl+alt+6': 'ctrlalt6'
        # -> #
        # focus pref term #
        'ctrl+alt+p': 'ctrlaltp'
        # focus new alt term #
        'ctrl+alt+a': 'ctrlalta'
        # focus new hidden term #
        'ctrl+alt+h': 'ctrlalth'
        'ctrl+alt+q': 'goToQuestUrl'
      }
  pathToQuest: Ember.computed 'model.id', 'currentUser.language',  ->
    target = @get('currentUser.language').toUpperCase()
    source = "EN"
    @modelFor(@routeName).get('defaultPrefLabel').then (label) ->
      "https://webgate.ec.testa.eu/questmetasearch/search.php?searchedText=#{label}&selectedSourceLang=#{source}&selectedDestLang=#{target}"

  hierarchyService: Ember.inject.service()
  model: (params) ->
    options ={}
    @store.findOneQuery('concept', params.id, options)
  afterModel: (model) ->
    @get('saveAllButton').clearSubscribers()
    @set 'hierarchyService.target', Ember.get(model, 'id')
    Ember.RSVP.all(['prefLabels', 'hiddenLabels', 'altLabels'].map (prop) -> model.get(prop)).then ->
      window.scrollTo(0, 0);

  hasDirtyTerms: ->
    dirty = false
    @get('controller').get('allTerms').forEach (term) ->
      if term.get('id') and term.get('dirty') then dirty = true
    return dirty
  resetDirtyTerms: ->
    @get('saveAllButton')?.resetAll()

  actions:
    goToQuestUrl: ->
      @get('pathToQuest').then (url) =>
        window.open(url)
    willTransition: (transition) ->
      if @hasDirtyTerms()
        if confirm("The changes to this concept will not be saved.\nProceed ?")
          @resetDirtyTerms()
          true
        else transition.abort()
      else
        true


    ctrlalt1: ->
      status = "to do"
      @get('controller').setStatusFromString(status)
    ctrlalt2: ->
      status = "in progress"
      @get('controller').setStatusFromString(status)
    ctrlalt3: ->
      status = "translated"
      @get('controller').setStatusFromString(status)
    ctrlalt4: ->
      status = "reviewed without comments"
      @get('controller').setStatusFromString(status)
    ctrlalt5: ->
      status = "reviewed with comments"
      @get('controller').setStatusFromString(status)
    ctrlalt6: ->
      status = "confirmed"
      @get('controller').setStatusFromString(status)
    ctrlaltp: ->
      Ember.run.next =>
        $('.tabbable[name=pref0]')[0]?.focus()
    ctrlalta: ->
      Ember.run.next =>
        $('.tabbable[name=altnew]')[0]?.focus()
    ctrlalth: ->
      Ember.run.next =>
        $('.tabbable[name=hiddennew]')[0]?.focus()

`export default ConceptsShowRoute`
