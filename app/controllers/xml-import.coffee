`import Ember from 'ember'`

XmlImportController = Ember.Controller.extend

  urlimport: "/translation-xml-import/import"
  urlvalidate: "/translation-xml-import/validate"
  #
  # urlimport: "http://" + window.location.hostname + ":7777/import"
  # urlvalidate: "http://" + window.location.hostname + ":7777/validate"

`export default XmlImportController`
