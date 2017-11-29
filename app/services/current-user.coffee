`import Ember from 'ember'`

CurrentUserService = Ember.Service.extend
  session: Ember.inject.service('session')
  store: Ember.inject.service('store')
  init: ->
    @_super(arguments...)
    # try get the current user, for if the user is still logged in through cookie
    @ensureUser()
  sessionAuthenticated: ->
    @ensureUser()
    @_super(arguments...)
  sessionInvalidated: ->
    @set 'user', null
    @_super(arguments...)
  userInGroup: (groupName) ->
    valid= false
    @get('groups')?.forEach (group) ->
      if group.get('name') is groupName
        valid= true
    return valid

  # TODO : Once we have new groups, refactor this #
  userIsTranslator: Ember.computed 'user', 'groups', ->
    #return true
    @userInGroup('EMPL_ESCOTRA')
  userIsReviewer: Ember.computed 'user', 'groups', ->
    @userInGroup('EMPL_ESCOTRA')
  userIsAdmin: Ember.computed 'user', 'groups', ->
    #return false
    @userInGroup('EMPL_ESCOTRAADM')

  disableShortcuts: Ember.computed 'user.disableShortcuts', ->
    disable = @get('user.disableShortcuts')
    if disable is "yes" then return true
    else return false

  dirtyLanguage: Ember.computed 'selectedLanguage', 'userLanguage', ->
    return @get('selectedLanguage') isnt @get('userLanguage')
  # language in which the information has to be displayed
  selectedLanguage: Ember.computed ->
    @get('user.language')
  # language the user is translating into
  userLanguage: Ember.computed.alias 'user.language'
  # first available language, which a priority on the displaying one
  language: Ember.computed 'selectedLanguage', 'userLanguage', ->
    @get('selectedLanguage') || @get('userLanguage') || "en"

  ensureUser: ->
    new Ember.RSVP.Promise (resolve, reject) =>
      accountId = @get('session.data.authenticated.relationships.account.data.id')
      if Ember.isEmpty(accountId)
        reject()
      else if @get('user')
        resolve()
      else
        setUser = ((user) =>
          @set('user', user)
          resolve())
        @get('store').find('account', accountId).then( (account) =>
          account.get('user').then (user) =>
            user.get('groups').then (groups) =>
              @set 'groups', groups
              setUser(user)
        ).catch(reject)

`export default CurrentUserService`
