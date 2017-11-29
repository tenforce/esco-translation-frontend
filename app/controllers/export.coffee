`import Ember from 'ember'`
`import {languagesIncludingEnglish} from '../utils/languages'`
`import ENV from '../config/environment'`
`import FileSaver from 'file-saver'`

ExportController = Ember.Controller.extend

  languageOptions: languagesIncludingEnglish
  language: {'id':'en', 'title':'English' }

  exportOptions: [{'title':'Occupations'}, {'title':'Skills', disabled:ENV.translation.disableTaxonomyChange}]
  exportType: {'title':'Occupations'}
  loading: false
  actions:
    setLanguage: (lang) ->
      @set 'language', lang #Ember.get(lang, 'id')
    setExportType: (et) ->
      @set 'exportType', et
    makeExport: ->
      if @get 'loading' then return undefined
      @set 'loading', true
      etype = "concept"
      if @get('exportType.title') == 'Skills'
        etype = "skill"
      $.ajax
        url: '/export?language=' + @get('language.id') + "&type=" + etype,
        type: 'GET',
        success: (data) =>
          Ember.Logger.log(data)
          size = 10000000
          while(data.length>0)
            if(data.length<size)
              blob = new Blob(["URI,ISCO,PT,NPT,HT\n#{data}"], {type: "text/csv;charset=utf-8"})
              FileSaver.saveAs(blob, "export.csv");
              data = ""
            else
              buff = data.substring(0, size)
              data = data.substring(size, data.length)
              fn = data.indexOf("\n")
              buff += data.substring(0, fn)
              data = data.substring(fn, data.length)
              blob = new Blob(["URI,ISCO,PT,NPT,HT\n#{buff}"], {type: "text/csv;charset=utf-8"})
              FileSaver.saveAs(blob, "export.csv");
          @set 'loading', false
        error: =>
          @set 'loading', false


`export default ExportController`
