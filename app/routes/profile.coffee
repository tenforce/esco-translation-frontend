`import Ember from 'ember'`
`import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin'`

ProfileRoute = Ember.Route.extend AuthenticatedRouteMixin,
  actions:
    willTransition: (transition) ->
      if @get('controller.dirty')
        if confirm("The changes to your profile will be lost after this session if you do not save.\nProceed ?")
          # could rollback changes
        else transition.abort()
      else
        true

`export default ProfileRoute`
