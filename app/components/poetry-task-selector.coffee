`import Ember from 'ember'`

PoetryTaskSelectorComponent = Ember.Component.extend

  init: ->
    this._super()
    @get('user')
  store: Ember.inject.service('store')
  currentUser: Ember.inject.service()
  user: Ember.computed.alias 'currentUser.user'
  nullTask: {id:undefined, poetryid:"All"}
  selectedTask: Ember.computed 'currentTask', ->
    task = @get('currentTask')
    if task?.get('id') then return task
    else return @nullTask
  currentTask: Ember.computed.alias 'user.poetryTask'
  tasks: Ember.computed ->
    # TODO : Only fetch poetry-tasks with poetry id
    @get('store').findAll('poetry-task').then (results) =>
      farray = []
      farray.push @nullTask
      array= []
      results.map (result) =>
        if result.get('poetryid')
          array.push(result)
      array.sort (a, b) ->
        if a.get('poetryid') < b.get('poetryid') then return -1
        if a.get('poetryid') > b.get('poetryid') then return 1
        return 0
      return farray.concat(array)

  actions:
    selectTask: (task) ->
      user = @get('user')
      user.set('poetryTask', task)
      user.save()

`export default PoetryTaskSelectorComponent`
