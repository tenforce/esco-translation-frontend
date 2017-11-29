`import DS from 'ember-data'`
`import HasManyQuery from 'ember-data-has-many-query'`
`import env from '../config/environment'`

PoetryTask = DS.Model.extend HasManyQuery.ModelMixin,
  readOnlyAttributes: ['poetryid']
  readOnlyRelationships: ['members']
  status: DS.attr('string')
  poetryid: DS.attr('string')
  members: DS.hasMany('task', inverse: null)
`export default PoetryTask`
