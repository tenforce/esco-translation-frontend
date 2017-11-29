`import Ember from 'ember'`

# This function receives the params `params, hash`
firstToUppercase = (params) ->
  return params[0][0].toUpperCase() + params[0].substr(1)

FirstToUppercaseHelper = Ember.Helper.helper firstToUppercase

`export { firstToUppercase }`

`export default FirstToUppercaseHelper`
