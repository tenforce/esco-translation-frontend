`import Ember from 'ember'`

NotificationsController = Ember.Controller.extend
  display: 'list'

  actions:
    setDisplay: (display) ->
      @set 'display', display
    update: (notification) ->
      @set 'selectedNotification', notification
      @set 'display', 'update'

`export default NotificationsController`
