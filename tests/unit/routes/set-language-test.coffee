`import { moduleFor, test } from 'ember-qunit'`

moduleFor 'route:set-language', 'Unit | Route | set language', {
  # Specify the other units that are required for this test.
  # needs: ['controller:foo']
}

test 'it exists', (assert) ->
  route = @subject()
  assert.ok route
