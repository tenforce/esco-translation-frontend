`import DS from 'ember-data'`
`import HasManyQuery from 'ember-data-has-many-query'`
`import env from '../config/environment'`

Task = DS.Model.extend HasManyQuery.ModelMixin,
  readOnlyAttributes: ['language']
  readOnlyRelationships: ['concept', 'member-of']
  language: DS.attr('string')
  status: DS.attr('string')
  concept: DS.belongsTo('concept', inverse: null)
  memberOf: DS.belongsTo('poetry-task', inverse: null)

  currentUser: Ember.inject.service()
  user: Ember.computed.alias 'currentUser.user'
  lastModifier: DS.belongsTo('user', inverse: null, async: false )
  lastModified: DS.attr('string')
  save: () ->
    if not @get('isDeleted')
      @set('lastModifier', @get('user'))
      @set('lastModified', (new Date()).toISOString())
    @_super(arguments...)
`export default Task`
