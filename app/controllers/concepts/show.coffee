`import Ember from 'ember'`

ConceptsShowController = Ember.Controller.extend
  notify: Ember.inject.service('notify')
  currentUser: Ember.inject.service()
  saveAllButton: Ember.inject.service()
  disableShortcuts: Ember.computed.alias 'currentUser.disableShortcuts'
  user: Ember.computed.alias 'currentUser.user'


  displayErrors: Ember.computed "checks.@each.display", ->
    displayTrue= (item, index, enumerable) ->
      if item?['display'] is true then return true
      return false
    return @get('checks').any(displayTrue)
  errorsMessage: Ember.computed "checks.@each.display", ->
    mess = ""
    @get('checks').forEach (check) ->
      if check?['display'] is true then mess += check?['message'] + "\n"
    return mess

  checks: Ember.computed 'loading', 'failedToSaveStatus', 'emptyPrefTerms', 'tooManyPrefTerms', 'checkPtWithoutNeutral', 'checkNoStandardMale', 'checkNoStandardFemale', 'checkNptWithoutGender', 'checkTooManyStandardMale', 'checkTooManyStandardFemale', ->
    if @get('loading') then return []
    names = ['failedToSaveStatus', 'emptyPrefTerms', 'tooManyPrefTerms', 'checkPtWithoutNeutral',
      'checkNoStandardMale', 'checkNoStandardFemale', 'checkNptWithoutGender', 'checkTooManyStandardMale', 'checkTooManyStandardFemale']
    arr = []
    names.forEach (name) =>
      arr.push(@get(name))
    return arr
  toggleCheck: (name, bool) ->
    Ember.set(@get(name), 'display', bool)


  # Checks and error messages to be displayed in case check fails
  # this check 'display' value is modified if an update of the status doesn't work
  failedToSaveStatus:
    {name:"failedToSaveStatus", display: false, message: "- An error occurred when changing the status"}

  emptyPrefTerms: Ember.computed 'prefTerms.length', ->
    display = false
    if @get('prefTerms.length') is 0
      display = true
    {name:"emptyPrefTerms", display: display, message: "- There is no preferred term for this language"}

  tooManyPrefTerms: Ember.computed 'prefTerms.length', ->
    display = false
    if @get('prefTerms.length') > 1
      display=true
    {name:"tooManyPrefTerms", display: display, message: "- There are too many preferred terms for this language"}

  newPtWithoutNeutral: Ember.computed 'newPrefTerm.roles.length', 'newPrefTerm.literalForm.length', ->
    term = @get('newPrefTerm')
    if term.get('literalForm.length') is 0 then return false
    if term.get('roles').contains(@get('rolesSet.neutral')) then return false
    return true
  ptWithoutNeutral: Ember.computed 'prefTerms.@each.roles.length', ->
    hasNeutral= (item, index, enumerable) ->
      unless item.get('id') then return false
      if item.get('roles').contains(@get('rolesSet.neutral')) then return true
      else return false
    return not @get('prefTerms').every(hasNeutral, @)
  checkPtWithoutNeutral: Ember.computed 'newPtWithoutNeutral', 'ptWithoutNeutral', ->
    display = false
    if @get('newPtWithoutNeutral') or @get('ptWithoutNeutral') then display = true
    {name:"ptWithoutNeutral", display: display, message: "- Missing neutral gender on a preferred term"}

  newTermHasStandardMale: Ember.computed 'newPrefTerm.roles.length','newPrefTerm.literalForm.length', 'newAltTerm.roles.length', 'newAltTerm.literalForm.length', ->
    hasStandard= (item, index, enumerable) =>
      if (not item.get('id')) and item.get('literalForm.length') > 0
        if item.get('roles').contains(@get('rolesSet.standardMale')) then return true
      return false
    pref = @get('newPrefTerm')
    alt = @get('newAltTerm')
    return hasStandard(pref) or hasStandard(alt)
  hasStandardMale: Ember.computed 'allTerms.@each.roles.length', ->
    hasStandard= (item, index, enumerable) =>
      unless item.get('id') then return false
      if item.get('roles').contains(@get('rolesSet.standardMale')) then return true
      else return false
    return @get('allTerms').any(hasStandard)
  checkNoStandardMale: Ember.computed 'newTermHasStandardMale', 'hasStandardMale', ->
    display = true
    if @get('newTermHasStandardMale') then display = false
    if @get('hasStandardMale') then display = false

    {name:"checkNoStandardMale", display: display, message: "- There is no standard male term specified for this language"}
  checkTooManyStandardMale: Ember.computed 'allTerms.@each.roles.length', ->
    terms = @get('allTerms')?.filter (term) =>
      if !term.get('id') and term.get('literalForm.length') is 0 then return false
      if term.get('roles').contains(@get('rolesSet.standardMale')) then return true
      else return false
    display = terms.get('length') > 1
    {name:"checkTooManyStandardMale", display: display, message: "- Too many standard male terms specified"}

  newTermHasStandardFemale: Ember.computed 'newPrefTerm.roles.length','newPrefTerm.literalForm.length', 'newAltTerm.roles.length', 'newAltTerm.literalForm.length', ->
    hasStandard= (item, index, enumerable) =>
      if (not item.get('id')) and item.get('literalForm.length') > 0
        if item.get('roles').contains(@get('rolesSet.standardFemale')) then return true
      return false
    pref = @get('newPrefTerm')
    alt = @get('newAltTerm')
    return hasStandard(pref) or hasStandard(alt)
  hasStandardFemale: Ember.computed 'allTerms.@each.roles.length', ->
    hasStandard= (item, index, enumerable) =>
      unless item.get('id') then return false
      if item.get('roles').contains(@get('rolesSet.standardFemale')) then return true
      else return false
    return @get('allTerms').any(hasStandard)
  checkNoStandardFemale: Ember.computed 'newTermHasStandardFemale', 'hasStandardFemale', ->
    display = true
    if @get('newTermHasStandardFemale') then display = false
    if @get('hasStandardFemale') then display = false
    {name:"checkNoStandardFemale", display: display, message: "- There is no standard female term specified for this language"}
  checkTooManyStandardFemale: Ember.computed 'allTerms.@each.roles.length', ->
    terms = @get('allTerms')?.filter (term) =>
      if !term.get('id') and term.get('literalForm.length') is 0 then return false
      if term.get('roles').contains(@get('rolesSet.standardFemale')) then return true
      else return false
    display = terms.get('length') > 1
    {name:"checkTooManyStandardFemale", display: display, message: "- Too many standard female terms specified"}

  newNptWithoutGender: Ember.computed 'newAltTerm.roles.length', 'newAltTerm.literalForm.length', ->
    term = @get('newAltTerm')
    if term.get('literalForm.length') is 0 then return false
    if term.get('roles.length') is 0 then return true
    return false
  nptWithoutGender: Ember.computed 'altTerms.@each.roles.length', 'newNptWithoutGender', ->
    hasNoGenders= (item, index, enumerable) ->
      unless item.get('id') then return false
      if item.get('roles.length') is 0 then return true
      else return false
    return @get('altTerms').any(hasNoGenders, @)
  checkNptWithoutGender: Ember.computed 'newNptWithoutGender', 'nptWithoutGender', ->
    display = false
    if @get('newNptWithoutGender') or @get('nptWithoutGender') then display = true
    return {name:"checkNptWithoutGender", display: display, message: "- A non-preferred term does not have any gender specified"}


  loadingTask: true
  task: undefined
  statusSelectorTitle: Ember.computed  ->
    'Change the status of this concept.'
  # we used to prevent status change for normal users if it was 'confirmed' but it has been removed
  allowStatusChange: Ember.computed 'task', 'currentUser.userIsAdmin', 'dirtyLanguage', ->
    unless @get('task') then return false
    if @get('currentUser.userIsAdmin') then return true
    else if @get('dirtyLanguage') then return false
    return true
  statusOptions: Ember.computed 'currentUser.userIsAdmin', 'currentUser.userIsTranslator', ->
    admin = @get('currentUser.userIsAdmin')
    user = @get('currentUser.userIsTranslator')
    [
      {name: "to do", disabled: ((!user) and (!admin))},
      {name: "in progress", disabled: ((!user) and (!admin))},
      {name: "translated", disabled: ((!user) and (!admin))},
      {name: "reviewed without comments", disabled: ((!user) and (!admin))},
      {name: "reviewed with comments", disabled: ((!user) and (!admin))},
      {name: "confirmed", disabled: ((!user) and (!admin))}
    ]
  status: Ember.computed.alias 'task.status'
  customStatus: Ember.computed 'status', ->
    status = @get('status')
    unless status then return undefined
    return {name: status, disabled:true}
  noStatus: {name: 'none', disabled: true}
  chosenStatus: Ember.computed 'status', 'statusOptions',  ->
    status = @get('status')
    return @get('statusOptions').filterBy('name', status).get('firstObject') || @get('customStatus') || @get('noStatus')

  setStatus: (status) ->
    unless status then return false
    if status['disabled'] is true then return false
    if @get('dirty')
      if confirm("Changes will be lost if you change status.\nProceed anyway?")
        @get('saveAllButton')?.resetAll()
      else return false

    oldstatus = @get('task.status')
    @set('status', status['name'])

    @toggleCheck('failedToSaveStatus', false)
    @set('savingTask', true)
    @get('task')?.save()?.then( (task) =>
      unless @get('isDestroyed')
        console.log "task status change success on save"
        #@set('failedToSaveStatus', false)
        @toggleCheck('failedToSaveStatus', false)
        @set('savingTask', false)
      return task
    ).catch( (error) =>
      console.log "task status change failure on save"
      unless @get('isDestroyed')
        @set('status', oldstatus)
        @get('notify').error('An error occurred when trying to change the status')
        #@set('failedToSaveStatus', true)
        @toggleCheck('failedToSaveStatus', true)
        @set('savingTask', false)
      throw error
  )

  setStatusFromString: (status) ->
    @setStatus(@get('statusOptions').filterBy('name', status)?[0])

  dirty: Ember.computed.alias 'saveAllButton.dirty'

  sourceLanguage: "en"
  targetLanguage: Ember.computed.alias 'currentUser.language'
  userLanguage: Ember.computed.alias 'currentUser.userLanguage'
  selectedLanguage: Ember.computed.alias 'currentUser.selectedLanguage'
  dirtyLanguage: Ember.computed.alias 'currentUser.dirtyLanguage'
  disableTranslation: Ember.computed 'currentUser.userIsAdmin', 'dirtyLanguage', 'status', 'task.id', ->
    if @get('currentUser.userIsAdmin') then return false
    if @get('dirtyLanguage') then return true
    if ["none", "confirmed", "reviewed without comments", "reviewed with comments", "locked"].contains @get('status') then return true
    return false
  setLanguage: (lang) ->
    # new terms will always be dirty so pop up will appear every time...
    if @get('dirty')
      if confirm("Changes will be lost if you change language.\nProceed anyway?")
        @get('saveAllButton')?.resetAll()
        @set 'selectedLanguage', lang.id
    else @set 'selectedLanguage', lang.id

  suggestions: Ember.computed 'model.id', 'sourceLanguage', 'targetLanguage', ->
    @get('model.defaultPrefLabel').then (label) =>
      source = @get('sourceLanguage')
      target = @get('targetLanguage')
      promise = Ember.$.ajax "/translate?term=#{label}&source_language=#{source}&target_languages=#{target}",
        headers:
          'Accept': 'application/json'
          'type':'GET'
      promise.then (result) =>
        res = []
        if result?.data
          res = result.data
        return res

  removeRoleFromTerms: (role) ->
    if role is @get('rolesSet.standardMale')
      sg = role
      g = @get('rolesSet.male')
    else if role is @get('rolesSet.standardFemale')
      sg = role
      g = @get('rolesSet.female')
    else return new Ember.RSVP.Promise =>
      return null

    promises = []
    @get('allTerms').forEach (term) ->
      promises.push(
        term.hasRole(sg).then (bool) ->
          if bool
            arr = []
            arr.push(term.setRole(sg, false))
            if term.get('prefLabelOf')
              arr.push(term.setRole(g, false))
            return Ember.RSVP.Promise.all(arr)
      )
    Ember.RSVP.Promise.all(promises)

  placeholder: "e.g., \"actress//sf\""

  loadingRoleSet: true
  rolesSet: {}

  loading: true
  loadingTerms: true
  prefTerms: []
  altTerms: []
  hiddenTerms: []
  allTerms: Ember.computed 'prefTerms.@each', 'altTerms.@each', 'hiddenTerms.@each', ->
    arr = [@get('newPrefTerm'), @get('newAltTerm'), @get('newHiddenTerm')]
    return arr.concat(@get('prefTerms'), @get('altTerms'), @get('hiddenTerms'))

  modelOrLanguageChangeChecker: Ember.observer('model.id', 'targetLanguage', ->
    # If those properties are not set, no point in going further
    unless @get('model.id') and @get('targetLanguage') then return

    @set('loading', true)
    promises = []

    console.log "Loading label-roles"
    @set('loadingRoleSet', true)
    promises.push @get('store').findAll('label-role').then (roles) =>
      roles.forEach (role) =>
        # setting custom order & labels for roles
        switch role.get('preflabel')
          when "standard male term"
            @set('rolesSet.standardMale', role)
            role.set('sortOrder', 1)
            role.set('displayLabel', "ST. MALE")
          when "standard female term"
            @set('rolesSet.standardFemale', role)
            role.set('sortOrder', 2)
            role.set('displayLabel', "ST. FEMALE")
          when "male"
            @set('rolesSet.male', role)
            role.set('sortOrder', 3)
            role.set('displayLabel', "MALE")
          when "female"
            @set('rolesSet.female', role)
            role.set('sortOrder', 4)
            role.set('displayLabel', "FEMALE")
          when "neutral"
            @set('rolesSet.neutral', role)
            role.set('sortOrder', 5)
            role.set('displayLabel', "NEUTRAL")
      @set('roles', roles.sortBy('sortOrder'))
      @set('loadingRoleSet', false)
      console.log "--- done getting roles ---"

    console.log "Getting task for [#{@get('model.id')} in (#{@get('targetLanguage')})"
    @set('loadingTask', true)
    promises.push @get('model.tasks').then (tasks) =>
      task = tasks.findBy('language', @get('targetLanguage'))
      if task is undefined
        @set('task', undefined)
        @set('loadingTask', false)
      else
        task.reload().then (loadedTask) =>
          @set('task', loadedTask)
          @set('loadingTask', false)
          console.log "--- done getting task---"

    console.log "Loading terms for [#{@get('model.id')}] in (#{@get('targetLanguage')})"
    @set('loadingTerms', true)
    prom = []
    prom.push @get('model.prefLabels').reload()
    prom.push @get('model.altLabels').reload()
    prom.push @get('model.hiddenLabels').reload()
    promises.push Ember.RSVP.Promise.all(prom).then =>
      Ember.RSVP.hash(
        pref: @get('model.localizedPrefLabels')
        alt: @get('model.localizedAltLabels')
        hidden: @get('model.localizedHiddenLabels')
      ).then (hash) =>
        pref = hash['pref']
        alt = hash['alt']
        hidden = hash['hidden']
        loadingRoles = []
        pref.concat(alt, hidden).forEach (term) ->
          loadingRoles.push(term.get('roles').reload())
        Ember.RSVP.Promise.all(loadingRoles).then =>
          @set('prefTerms', pref)
          @set('altTerms', alt)
          @set('hiddenTerms', hidden)
          @set('loadingTerms', false)
          console.log "--- done loading terms ---"

    Ember.RSVP.Promise.all(promises).then =>
      console.log "Preparing new terms for [#{@get('model.id')}] in (#{@get('targetLanguage')})"
      @generateNewPrefTerm()
      @generateNewAltTerm()
      @generateNewHiddenTerm()
      @set('loading', false)
      console.log "--- done preparing new terms ---"
  ).on('init')
  generateTerm: () ->
    @get('store').createRecord('conceptLabel', literalFormValues: [{content: "", language: @get('targetLanguage')}])
  # function to create terms
  generateNewPrefTerm: () ->
    @set('newPrefTerm', @createPrefTerm())
  createPrefTerm: () ->
    term = @generateTerm()
    term.set('prefLabelOf', @get('model'))
    term.setRole(@get('rolesSet.neutral'), true)
    term
  generateNewAltTerm: () ->
    @set('newAltTerm', @createAltTerm())
  createAltTerm: () ->
    term = @generateTerm()
    term.set('altLabelOf', [@get('model')])
    term
  generateNewHiddenTerm: () ->
    @set('newHiddenTerm', @createHiddenTerm())
  createHiddenTerm: () ->
    term = @generateTerm()
    term.set('hiddenLabelOf', [@get('model')])
    term
  # terms that will be passed as parameters
  newPrefTerm: undefined
  newAltTerm: undefined
  newHiddenTerm: undefined

  deleteTerm: (term, name, index) ->
    term.deleteRecord()
  rollbackTerm: (term, name, index) ->
    console.log "Handle reset of term"
    if term.get('id') then term.reload().then().catch (error) =>
      @get('notify').error('An error occurred when trying to reload this term')
    else
      term.set('literalForm', '')
      term.set('roles', [])
      term.set('source', undefined)
  saveTerm: (list, addToList, term, name, index) ->
    if term.get('literalForm.length') is 0 and term.get('isDeleted') is false
      console.log "can not save empty term"
      @get('notify').warning({html:"<span>You can not save an empty term.</span><br/><span>If you want to delete it, please use the [-] button located on the right side of the term.</span>"})
      return false
    console.log "Handle saving of term"
    term.save().then( (savedTerm) =>
      unless @get('isDestroyed')
        console.log "success on save"
        if savedTerm.get('isDeleted')
          list.removeObject(term)
        else
          if addToList
            list.addObject(term)
    ).catch (error) =>
      throw error
  # Message needs to be different and some other things might change too
  # TODO : extract duplicate code
  savePrefTerm: (list, addToList, term, name, index) ->
    if term.get('literalForm.length') is 0 and term.get('isDeleted') is false
      console.log "can not save empty pref term"
      @get('notify').warning({html:"<span>You can not save an empty preferred term.</span>"})
      return false
    console.log "Handle saving of term"
    term.save().then( (savedTerm) =>
      unless @get('isDestroyed')
        console.log "success on save"
        if savedTerm.get('isDeleted')
          list.removeObject(term)
        else
          if addToList
            list.addObject(term)
    ).catch (error) =>
      throw error

  showGendersBox: Ember.computed 'model.isOccupation', 'model.isSkill', ->
    if @get 'model.isOccupation' then return true
    else if @get 'model.isSkill' then return false
    return true

  pathToQuest: Ember.computed 'model.id', 'user.language',  ->
    target = @get('user.language').toUpperCase()
    source = "EN"
    @get('model.defaultPrefLabel').then (label) ->
      "https://webgate.ec.testa.eu/questmetasearch/search.php?searchedText=#{label}&selectedSourceLang=#{source}&selectedDestLang=#{target}"

  collapsed: true
  toggleTooltip: Ember.computed 'collapsed', ->
    if @get('collapsed') is true then return "Show more information"
    else "Show less information"
  defaultConceptDescriptionTagName: 'div'
  conceptDescriptionTagName: Ember.computed 'conceptDescription.tagName', 'defaultConceptDescriptionTagName', ->
    if @get 'conceptDescription.tagName' then @get 'conceptDescription.tagName'
    else @get 'defaultConceptDescriptionTagName'

  defaultConceptDescriptionClassNames: ['']
  conceptDescriptionClassNames: Ember.computed 'conceptDescription.classNames', 'defaultConceptDescriptionClassNames', ->
    if @get 'conceptDescription.classNames' then @get 'conceptDescription.classNames'
    else @get 'defaultConceptDescriptionClassNames'

  conceptDescriptionClass: Ember.computed 'concept.isOccupation', 'concept.isSkill', ->
    if @get 'concept.isOccupation' then return 'occupation'
    else if @get 'concept.isSkill' then return 'skill'
    else return 'occupation' # by default, for ISCO concepts

  conceptDescription: Ember.computed ->
    title:
      classNames: ['concept-header']
      tagName: 'div'
      label:
        classNames: ['label']
        tagName: 'div'
        type: 'property'
        name: 'iscoValue'
      target:
        classNames: ['main-title']
        tagName: 'h1'
        type: 'property'
        name: 'defaultPrefLabel'
    ,
    headings:
      classNames: ['concept-detail']
      tagName: 'div'
      values:
        [
          # {
          #   classNames: ['concept-block concept-block-breadcrumb']
          #   tagName: 'div'
          #   items:
          #     values:
          #       [
          #         {
          #           classNames: ['inner inner-breadcrumb']
          #           tagName: 'div'
          #           target:
          #             type: 'property'
          #             name: 'breadcrumb'
          #         },
          #       ]
          #   },
          {
            classNames: ['concept-block concept-block-info']
            tagName: 'div'
            title:
              classNames: ['']
              tagName: 'h2'
              target:
                type: 'string'
                name: 'Concept info'
            items:
              values:
                [
                  {
                    classNames: ['inner inner-description']
                    tagName: 'div'
                    label:
                      tagName: 'h3'
                      type: 'string'
                      name: 'description'
                    target:
                      type:'component'
                      name: 'formatted-description'
                      properties:
                        name: 'defaultDescription'
                  },
                  {
                    classNames: ['inner inner-terms']
                    tagName: 'div'
                    target:
                      type: 'component'
                      name: 'term-list'
                      properties:
                        targetLanguage: @get('targetLanguage')
                  },
                  {
                    classNames: ['inner inner-notes']
                    tagName: 'div'
                    label:
                      tagName: 'h3'
                      type: 'string'
                      name: 'Scope notes'
                    target:
                      type: 'property'
                      name: 'defaultScopeNote'
                  },
                  {
                    classNames: ['inner inner-code isco']
                    tagName: 'div'
                    label:
                      tagName: 'h3'
                      type: 'string'
                      name: 'ISCO-08'
                    target:
                      type: 'property'
                      name: 'iscoLabeledCode'
                  },
                  {
                    classNames: ['inner inner-code nace']
                    tagName: 'div'
                    label:
                      tagName: 'h3'
                      type: 'string'
                      name: 'NACE code'
                    target:
                      type: 'property'
                      name: 'naceCode'
                  }
                ]
          },
          {
            classNames: ['concept-block concept-block-related']
            tagName: 'div'
            title:
              classNames: ['']
              tagName: 'h2'
              target:
                type: 'string'
                name: 'Related skills / competences'
            items:
              values:
                [
                  {
                    target:
                      type:'component'
                      name:'show-skills'
                      tagName: 'div'
                      classNames: ['inner inner-skills']
                      properties:
                        title: 'Essential'
                        skillRelation: 'essentialSkills'
                  },
                  {
                    target:
                      type:'component'
                      name:'show-skills'
                      tagName: 'div'
                      classNames: ['inner inner-skills']
                      properties:
                        title: 'Optional'
                        skillRelation: 'optionalSkills'
                  }
                ]
          },
          {
            classNames: ['concept-block concept-block-related']
            tagName: 'div'
            title:
              classNames: ['']
              tagName: 'h2'
              target:
                type: 'string'
                name: 'Related knowledge'
            items:
              values:
                [
                  {
                    target:
                      type:'component'
                      name:'show-skills'
                      tagName: 'div'
                      classNames: ['inner inner-skills']
                      properties:
                        title: 'Essential'
                        skillRelation: 'essentialKnowledges'
                  },
                  {
                    target:
                      type:'component'
                      name:'show-skills'
                      tagName: 'div'
                      classNames: ['inner inner-skills']
                      properties:
                        title: 'Optional'
                        skillRelation: 'optionalKnowledges'
                  }
                ]
          },
          {
            classNames: ['concept-block concept-block-related']
            tagName: 'div'
            title:
              classNames: ['']
              tagName: 'h2'
              target:
                type: 'string'
                name: 'Related occupations'
            items:
              values:
                [
                  {
                    target:
                      type:'component'
                      name:'show-skills'
                      tagName: 'div'
                      classNames: ['inner inner-skills']
                      properties:
                        title: 'Essential for'
                        skillRelation: 'essentialSkillFor'
                  },
                  {
                    target:
                      type:'component'
                      name:'show-skills'
                      tagName: 'div'
                      classNames: ['inner inner-skills']
                      properties:
                        title: 'Optional for'
                        skillRelation: 'optionalSkillFor'
                  }
                ]
          },
          {
            classNames: ['concept-block concept-block-regulatory']
            tagName: 'div'
            title:
              classNames: ['']
              tagName: 'h2'
              target:
                type:  'string'
                name: 'Regulatory aspects'
            items:
              values:
                [
                  {
                    target:
                      type: 'property'
                      name: 'TODEFINE'
                  },
                  {
                    target:
                      type: 'property'
                      name: 'TODEFINE'
                  }
                ]
          }
        ]

  actions:
    toggleDetail: ->
      @toggleProperty("collapsed")
      false
    toggleHelp: ->
      @toggleProperty("toggleHelp")
      false

    saveAll: ->
      @get('saveAllButton').saveAll()

    rollbackTerm: (term, name, index) ->
      @rollbackTerm(term, name, index)
    deleteTerm: (term, name, index) ->
      console.log "deleted term [#{term.get('id')}] (index : #{index}) with name : #{name}"
      @deleteTerm(term, name, index)
    savePrefTerm: (term, name, index) ->
      console.log "Saved pref term [#{term.get('id')}] (index : #{index}) with name : #{name}"
      prom = @savePrefTerm(@get('prefTerms'), false, term, name, index)
      prom.catch (reason) => @get('notify').error('An error occurred when trying to save this preferred term')
    saveNewPrefTerm: (term, name, index) ->
      console.log "Saved new pref term [#{term.get('id')}] (index : #{index}) with name : #{name}"
      prom = @savePrefTerm(@get('prefTerms'), true, term, name, index)
      prom.then () => @generateNewPrefTerm()
      prom.catch (reason) => @get('notify').error('An error occurred when trying to save this new preferred term')
    saveAltTerm: (term, name, index) ->
      console.log "Saved alt term [#{term.get('id')}] (index : #{index}) with name : #{name}"
      prom = @saveTerm(@get('altTerms'), false, term, name, index)
      prom.catch (reason) => @get('notify').error('An error occurred when trying to save this non-preferred term')
    saveNewAltTerm: (term, name, index) ->
      prom = @saveTerm(@get('altTerms'), true, term, name, index)
      prom.then () => @generateNewAltTerm()
      prom.catch (reason ) => @get('notify').error('An error occurred when trying to save this new non-preferred term')
    saveHiddenTerm: (term, name, index) ->
      console.log "Saved hidden term [#{term.get('id')}] (index : #{index}) with name : #{name}"
      prom = @saveTerm(@get('hiddenTerms'), false, term, name, index)
      prom.catch (reason) => @get('notify').error('An error occurred when trying to save this hidden term')
    saveNewHiddenTerm: (term, name, index) ->
      console.log "Saved new hidden term [#{term.get('id')}] (index : #{index}) with name : #{name}"
      prom = @saveTerm(@get('hiddenTerms'), true, term, name, index)
      prom.then () => @generateNewHiddenTerm()
      prom.catch (reason ) => @get('notify').error('An error occurred when trying to save this new hidden term')

    # pref terms have to be neutral, can have sf/sm and if they have a standard, they should have non-standard too
    togglePrefGender: (term, role, name, index) ->
      console.log "Changing #{role.get('preflabel')} on pref term [#{term.get('id')}] (index : #{index}) with name : #{name}"
      # TODO : document
      # TODO : maybe if/else instead of checking everything every time
      if role is @get('rolesSet.neutral')
        term.hasRole(role).then (bool) =>
          if bool then @get('notify').warning('You can not remove the "neutral" gender for preferred terms.')
          else term.setRole(@get('rolesSet.neutral'), true)
          return false
      # just to make sure that pref terms have genders nonetheless
      else term.setRole(@get('rolesSet.neutral'), true)

      if role is @get('rolesSet.standardMale')
        term.hasRole(role).then (bool) =>
          if bool
            term.setRole(@get('rolesSet.standardMale'), false)
            term.setRole(@get('rolesSet.male'), false)
          else
            @removeRoleFromTerms(role).then =>
              term.setRole(@get('rolesSet.standardMale'), true)
              term.setRole(@get('rolesSet.male'), true)
        return false

      if role is @get('rolesSet.standardFemale')
        term.hasRole(role).then (bool) =>
          if bool
            term.setRole(@get('rolesSet.standardFemale'), false)
            term.setRole(@get('rolesSet.female'), false)
          else
            @removeRoleFromTerms(role).then =>
              term.setRole(@get('rolesSet.standardFemale'), true)
              term.setRole(@get('rolesSet.female'), true)
        return false

      if role is @get('rolesSet.male')
        Ember.RSVP.hash({g: term.hasRole(@get('rolesSet.male')), sg: term.hasRole(@get('rolesSet.standardMale'))}).then (hash) =>
          if hash['g'] is false
            if hash['sg'] is true then term.setRole(@get('rolesSet.male'), true)
            else
              @get('notify').warning('You can only set the "male" gender for preferred terms if they have the "standard male" gender.')
          if hash['g'] is true
            if hash['sg'] is false then term.setRole(@get('rolesSet.male'), false)
            else
              @get('notify').warning('You can only remove the "male" gender for preferred terms if they do not have the "standard male" gender.')
        return false

      if role is @get('rolesSet.female')
        Ember.RSVP.hash({g: term.hasRole(@get('rolesSet.female')), sg: term.hasRole(@get('rolesSet.standardFemale'))}).then (hash) =>
          if hash['g'] is false
            if hash['sg'] is true then term.setRole(@get('rolesSet.female'), true)
            else @get('notify').warning('You can only set the "female" gender for preferred terms if they have the "standard female" gender.')
          if hash['g'] is true
            if hash['sg'] is false then term.setRole(@get('rolesSet.female'), false)
            else @get('notify').warning('You can only remove the "female" gender for preferred terms if they do not have the "standard female" gender.')
        return false

    # alt terms can have all genders but if it has a standard one, it should also have the non standard version of it
    toggleAltGender: (term, role, name, index) ->
      console.log "Changing #{role.get('preflabel')} on alt term [#{term.get('id')}] (index : #{index}) with name : #{name}"

      if role is @get('rolesSet.standardMale')
        term.hasRole(role).then (bool) =>
          if bool
            term.setRole(@get('rolesSet.standardMale'), false)
            # we don't want to toggle off not standard gender
            #term.setRole(@get('rolesSet.male'), false)
          else
            @removeRoleFromTerms(role).then =>
              # if standard, should also be non-standard
              term.setRole(@get('rolesSet.standardMale'), true)
              term.setRole(@get('rolesSet.male'), true)
        return false

      if role is @get('rolesSet.standardFemale')
        term.hasRole(role).then (bool) =>
          if bool
            term.setRole(@get('rolesSet.standardFemale'), false)
            # we don't want to toggle off not standard gender
            #term.setRole(@get('rolesSet.female'), false)
          else
            @removeRoleFromTerms(role).then =>
              # if standard, should also be non-standard
              term.setRole(@get('rolesSet.standardFemale'), true)
              term.setRole(@get('rolesSet.female'), true)
        return false

      if role is @get('rolesSet.male')
        Ember.RSVP.hash({g: term.hasRole(@get('rolesSet.male')), sg: term.hasRole(@get('rolesSet.standardMale'))}).then (hash) =>
          # if the standard is specified, we can not toggle off the non-standard gender
          if hash['sg'] is true then @get('notify').warning('You can only remove the "male" gender for non-preferred terms if they do not have the "standard male" gender.')
          else term.toggleRole(role)
        return false

      if role is @get('rolesSet.female')
        Ember.RSVP.hash({g: term.hasRole(@get('rolesSet.female')), sg: term.hasRole(@get('rolesSet.standardFemale'))}).then (hash) =>
          # if the standard is specified, we can not toggle off the non-standard gender
          if hash['sg'] is true then @get('notify').warning('You can only remove the "female" gender for non-preferred terms if they do not have the "standard female" gender.')
          else term.toggleRole(role)
        return false

      term.toggleRole(role)

    # hidden terms can not have genders so we only allow to untoggle them
    toggleHiddenGender: (term, role, name, index) ->
      console.log "Changing #{role.get('preflabel')} on hidden term [#{term.get('id')}] (index : #{index}) with name : #{name}"
      # NB : use toggleRole if hidden labels should be able to have a gender set through the platform
      term.setRole(role, false)

    setLanguage: (lang) ->
      @setLanguage(lang)
    setStatus: (status) ->
      @setStatus(status)

    saveValue: (propname, dispname, newvalue, oldvalue, save) ->
      model = @get('model')
      unless model then return false
      model.addPropertyToSave(propname, dispname, newvalue, oldvalue)
      if save then return model.save()
      model

    goToQuest: (text) ->
      text = escape(text)
      target = escape(@get('targetLanguage')).toUpperCase()
      source = escape('en').toUpperCase()
      url = "https://webgate.ec.testa.eu/questmetasearch/search.php?searchedText=#{text}&selectedSourceLang=#{source}&selectedDestLang=#{target}"
      window.open(url)



`export default ConceptsShowController`

