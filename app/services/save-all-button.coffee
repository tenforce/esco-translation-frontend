`import Ember from 'ember'`



# Ember objects can subscribe to this service to receive a saveAllClick() if
# they have a truthy 'dirty' property, when this service's saveAll() is called.
SaveAllButtonService = Ember.Service.extend

  subscriptions: []

  # Any of the subscribers have a truthy 'dirty' property
  dirty: Ember.computed "subscriptions.@each.dirty", ->
    @get('subscriptions').isAny('dirty')

  subscribe: (subscriber) ->
    @get('subscriptions').pushObject(subscriber)

  unsubscribe: (subscriber) ->
    @get('subscriptions').removeObject(subscriber)

  clearSubscribers: () ->
    @set('subscriptions', [])

  saveAll: ->
    @get('subscriptions').forEach (subscriber) ->
      if subscriber.get('dirty')
        subscriber.saveAllClick()
  resetAll: ->
    @get('subscriptions').forEach (subscriber) ->
      if subscriber.get('dirty')
        subscriber.resetAllClick()



`export default SaveAllButtonService`
