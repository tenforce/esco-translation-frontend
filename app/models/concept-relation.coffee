`import DS from 'ember-data'`
`import ESCO from 'ember-esco-concept-description'`

ConceptRelation = DS.Model.extend ESCO.Relation,
  readOnlyRelationships: ['from', 'to']

`export default ConceptRelation`
