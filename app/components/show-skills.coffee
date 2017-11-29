`import Ember from 'ember'`
`import layout from '../templates/components/show-skills'`

ShowSkillsComponent = Ember.Component.extend
  layout: layout
  tagName: ''
  showSkillList: false
  hierarchyCache: Ember.inject.service()
  skillLimit: 50
  fullDetail: false
# the skills to be passed in
  skillRelation: undefined
  skillNumber: ''

  concept: Ember.computed.alias 'object'


  skills: Ember.computed 'concept', 'skillRelation', ->
    @get "concept.#{@get('skillRelation')}"

  skillsToDisplay: Ember.computed 'skillLimit', 'shadowSkills', 'sortedSkills', ->
    limit = @get('skillLimit')
    Ember.RSVP.hash(
      shadow: @get('shadowSkills')
      skills: @get('sortedSkills')
    ).then (hash) =>
      if hash.shadow
        @set('skillNumber', limit)
        return hash.skills.slice(0, limit)
      else
        @set('skillNumber', hash.skills.length)
        return hash.skills

  shadowSkills: Ember.computed 'fullDetail','skillLimit', 'skills', 'skills.length', ->
    if @get('fullDetail') then return false

    limit = @get('skillLimit')
    @get('skills').then (result) ->
      if not limit or (Ember.get(result, 'length')) <= limit
        return false
      else
        return true

  sortedSkills: Ember.computed 'skills', ->
    self = this
    @get('skills').then (skills) ->
      promises = []
      skills.map (skill) ->
        promises.push(skill)
      Ember.RSVP.all(promises).then (resolvedSkills)->
        self.sortByPromise(resolvedSkills, 'defaultPrefLabel')

  showSkills: Ember.computed 'skills', ->
    @get('skills').then (skills) ->
      not Ember.isEmpty(skills)

  checkEmpty: Ember.observer('showSkills', ->
# TODO check why?
    @get('showSkills').then (result) =>
      unless result then @sendAction('emptyComponent', @get('model'))
  ).on('init')

  toggleTooltip: "Click to show the full list"

  typeWatcher: Ember.inject.service('concept-type-watcher')
  occupationsOrigin: Ember.computed.alias 'typeWatcher.occupationsOrigin'
  skillsOrigin: Ember.computed.alias 'typeWatcher.skillsOrigin'
  selectedOrigin: Ember.computed.alias 'typeWatcher.selectedOrigin'
  sortByPromise: (list, path) ->
    unless Ember.isArray(path)
      path = [path]

    promises = list.map (item) ->
      hash = {}
      path.map (key) ->
        hash[key] = new Ember.RSVP.Promise (resolve) -> resolve(Ember.get(item, key))
      Ember.RSVP.hash hash
    Ember.RSVP.all(promises).then (resolutions) ->
      toSort = resolutions.map (solutions, index) ->
        result = { _sorterItem: list.objectAt(index) }
        for key, solution of solutions
          result[key] = solution
        result
      sorted = toSort.sortBy.apply toSort, path
      sorted.map (item) ->
        item._sorterItem

  actions:
    showElements: ->
      @toggleProperty('showSkillList')
      false
    toggleDetail: ->
      @toggleProperty 'fullDetail'
    handleSkillClick: (skill) ->
      ###if skill.get('isOccupation')
        @set('selectedOrigin', @get('occupationsOrigin'))###
      # where did the hierarchyCache disappear?
      #@set 'hierarchyCache.hasPath', false
      @sendAction 'skillClick', skill

`export default ShowSkillsComponent`
