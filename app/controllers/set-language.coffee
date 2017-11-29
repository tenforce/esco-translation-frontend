`import Ember from 'ember'`
`import {languages} from '../utils/languages'`

SetLanguageController = Ember.Controller.extend
  session: Ember.inject.service('session')
  config: Ember.inject.service()
  currentUser: Ember.inject.service()
  user: Ember.computed.alias 'currentUser.user'
  languageOptions: languages
  actions:
    setLanguage: (lang) ->
      user = @get('user')
      user.set('language', lang.id)
      user.save().then(=>
        @transitionToRoute('concepts', @get('config.settings.occupationScheme'))
      )
`export default SetLanguageController`
