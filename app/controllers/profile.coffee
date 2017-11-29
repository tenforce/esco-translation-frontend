`import Ember from 'ember'`
`import {languages} from '../utils/languages'`
`import UserRights from '../mixins/user-rights'`

ProfileController = Ember.Controller.extend UserRights,
  notify: Ember.inject.service('notify')
  userGroupTexts: Ember.computed 'userIsAdmin', 'userIsTranslator', ->
    if(@get('userIsAdmin') and @get('userIsTranslator'))
      return 'BASIC USER, ADMIN'
    else if @get('userIsAdmin')
      return 'ADMIN'
    else if @get('userIsTranslator')
      return 'BASIC USER'
    ""
  loadingUser: Ember.computed 'user.id', ->
    if @get('user.id') then return false
    else return true
  currentUser: Ember.inject.service()
  user: Ember.computed.alias 'currentUser.user'
  classNames: ["main-header"]
  languages: languages

  selectedLanguage: Ember.computed.alias 'currentUser.selectedLanguage'
  browsingLanguage: Ember.computed 'selectedLanguage', ->
    @get('languages').findBy('id', @get('selectedLanguage'))

  userLanguage: Ember.computed.alias 'currentUser.userLanguage'
  translationLanguage: Ember.computed 'userLanguage', ->
    @get('languages').findBy('id', @get('userLanguage'))

  language: Ember.computed 'selectedLanguage', ->
    @get('languages').findBy('id', @get('selectedLanguage'))

  name: Ember.computed.oneWay "user.name"
  toggleBooleanProp: (name) ->
    current = @get name
    if current == "yes"
      @set name, "no"
    else
      @set name, "yes"

  disableShortcutsLabel: Ember.computed 'user.disableShortcuts', ->
    if @get('user.disableShortcuts') is "no" then return "Shortcuts are enabled"
    else if @get('user.disableShortcuts') is "yes" then return "Shortcuts are disabled"

  dirty: Ember.computed.or 'user.hasDirtyAttributes', 'dirtyName'
  dirtyName: Ember.computed 'name', 'user.name', ->
    return @get('name') isnt @get('user.name')

  actions:
    toggleDisableShortcuts: ->
      @toggleBooleanProp("user.disableShortcuts")
    updateProfile: ->
      @set 'loading', true
      user = @get('user')
      user.set('name', @get('name'))
      user.save().then(
        =>
          @get('notify').success('Profile saved successfully')
          @set 'loading', false
      ,
        =>
          @get('notify').error('An error occurred when trying to update your profile')
          @set 'loading', false
      )
    setName: (name) ->
      @set 'name', name
    setBrowsingLanguage: (lang) ->
      @set('selectedLanguage', lang.id)
    setTranslationLanguage: (lang) ->
      @set('userLanguage', lang.id)

`export default ProfileController`
