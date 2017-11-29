`import DS from 'ember-data'`

JSONAPISerializer = DS.JSONAPISerializer.extend
  serialize: (snapshot, options) ->
    json = @_super(arguments...)
    readOnlyAttributes = snapshot.record.get('readOnlyAttributes')
    readOnlyAttributes?.forEach (attribute) ->
      delete json?.data?.attributes?[attribute]
    readOnlyRelationships = snapshot.record.get('readOnlyRelationships')
    readOnlyRelationships?.forEach (relation) ->
      delete json?.data?.relationships?[relation]
    json
`export default JSONAPISerializer`
