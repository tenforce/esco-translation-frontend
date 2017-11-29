`import { moduleFor, test } from 'ember-qunit'`

moduleFor 'route:xml-import', 'Unit | Route | xml import', {
  # Specify the other units that are required for this test.
  # needs: ['controller:foo']
}

test 'it exists', (assert) ->
  route = @subject()
  assert.ok route
