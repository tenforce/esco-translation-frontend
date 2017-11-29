`import Ember from 'ember'`
`import Transform from 'ember-data/transform'`

LangStringSet = Transform.extend
  deserialize: (serialized) ->
    if (serialized && Ember.typeOf(serialized) == 'array')
      serialized.map((o) -> Ember.Object.create(o))
    else
      console.log "lang string set should be an array"
  serialize: (deserialized) ->
    return deserialized

`export default LangStringSet`
