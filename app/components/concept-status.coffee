`import Ember from 'ember'`
`import ENV from '../config/environment'`

ConceptStatusComponent = Ember.Component.extend
  session: Ember.inject.service('session')
  store: Ember.inject.service('store')
  currentUser: Ember.inject.service()
  user: Ember.computed.alias 'currentUser.user'
  language: Ember.computed.alias 'currentUser.selectedLanguage'
  classNames:["status"]
  classNameBindings: ["status"]
  attributeBindings: ["title"]

  modelObserver: Ember.observer 'model', 'language', 'model.tasks', (->
    @retrieveTask()
  ).on('init')
  retrieveTask: ->
    @set('loadingTask', true)
    @set('task', undefined)
    @get('model.tasks').then((tasks) =>
      unless @get('isDestroyed')
        task = tasks.findBy('language', @get('language'))
        @set 'task', task
        @set('loadingTask', false)
    ).catch (reason) =>
      unless @get('isDestroyed')
        @set 'task', undefined
        console.log "Could not fetch task for concept with id : "+@get('model.id')
        @set('loadingTask', false)

  status: Ember.computed 'task.status', ->
    @get 'task.status'
  title: Ember.computed 'status', ->
    statusName = @get('status')
    title = "sorry, this status is unknown"
    ENV.statuses.map (status) ->
      if status.id == statusName
        title = status.explained
    title

`export default ConceptStatusComponent`
