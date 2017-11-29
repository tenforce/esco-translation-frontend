`import Ember from 'ember'`
`import env from '../config/environment'`
ConfigService = Ember.Service.extend
  settings: Ember.Object.create env.translation

`export default ConfigService`
