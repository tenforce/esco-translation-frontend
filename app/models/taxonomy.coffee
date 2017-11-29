`import DS from 'ember-data'`
`import ESCO from 'ember-esco-concept-description'`

Taxonomy = DS.Model.extend ESCO.Pillar,
  children: Ember.computed.alias 'topConcepts'
  readOnlyAttributes: ['description', 'preflabel']
  readOnlyRelationships: ['topConcepts', 'structures' ]

`export default Taxonomy`
