`import Ember from 'ember'`
`import ClickElsewhereMixin from '../mixins/click-elsewhere'`
`import UserRights from '../mixins/user-rights'`

NavBarComponent = Ember.Component.extend ClickElsewhereMixin, UserRights,
  session: Ember.inject.service('session')
  tasks: Ember.inject.service('user-tasks')
  percentages: Ember.computed.alias 'tasks.percentages'
  classNames: ["main-header"]

  onClickElsewhere: ->
    @set('menuClosed', true)
  menuClosed: true

  allowedOnNotifications: Ember.computed 'userIsAdmin', ->
    @get('userIsAdmin')
  allowedOnValidation: Ember.computed 'userIsAdmin', 'userIsReviewer', ->
    @get('userIsAdmin') or @get('userIsReviewer')

  init: ->
    @_super(arguments)
    #@get('tasks').fetchTasks(true)
  actions:
    closeMenu: ->
      @set('menuClosed', true)
    toggleMenu: ->
      @toggleProperty('menuClosed')
    handleClick: (notification) ->
      notification.get('comment.about')?.then (concept) =>
        @sendAction('activateItem', concept)

`export default NavBarComponent`
