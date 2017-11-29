`import DS from 'ember-data'`
`import ValidationMixinResult from 'validation-addon/mixins/validation-result'`

ValidationResult = DS.Model.extend ValidationMixinResult,
  parameterDuplicateIn: DS.attr('string-set')
  parameterDuplicateType: DS.attr('string-set')
  parameterLabel: DS.attr('string-set')
  parameterLabels: DS.attr('string-set')
  parameterTotal: DS.attr('string-set')
  parameterGenders: DS.attr('string-set')
  parameterLiteralForms: DS.attr('string-set')

`export default ValidationResult`
