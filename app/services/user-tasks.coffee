`import Ember from 'ember'`

UserTasksService = Ember.Service.extend
  config: Ember.inject.service()
  currentUser: Ember.inject.service()
  user: Ember.computed.alias 'currentUser.user'
  language: Ember.computed.alias 'user.language'
  poetryTask: Ember.computed.alias 'user.poetryTask'
  lastFetched: null
  todo: 0
  conceptupdated: 0
  totalTodo: Ember.computed 'todo', 'conceptupdated', ->
    return +@todo+ +@conceptupdated
  inprogress: 0
  translated: 0
  reviewedwithoutcomments: 0
  reviewedwithcomments: 0
  totalReviewed: Ember.computed 'reviewedwithoutcomments', 'reviewedwithcomments', ->
    return +@reviewedwithoutcomments+ +@reviewedwithcomments
  confirmed: 0
  total: Ember.computed 'totalTodo', 'inprogress', 'translated', 'totalReviewed', 'confirmed', ->
    totalTodo = @get 'totalTodo'
    inprogress = @get 'inprogress'
    translated = @get 'translated'
    totalReviewed = @get 'totalReviewed'
    confirmed = @get 'confirmed'
    return +totalTodo + +inprogress + +translated + +totalReviewed + +confirmed
  totalTodoPercent: Ember.computed 'totalTodo', 'total', ->
    return (@get('totalTodo')/@get('total'))*100
  inprogressPercent: Ember.computed 'inprogress', 'total', ->
    return (@get('inprogress')/@get('total'))*100
  translatedPercent: Ember.computed 'translated', 'total', ->
    return (@get('translated')/@get('total'))*100
  totalReviewedPercent: Ember.computed 'reviewedwithoutcomments', 'total', ->
    return (@get('totalReviewed')/@get('total'))*100
  confirmedPercent: Ember.computed 'confirmed', 'total', ->
    return (@get('confirmed')/@get('total'))*100
  percentages: Ember.computed 'totalTodo', 'inprogress', 'translated', 'totalReviewed', 'confirmed', ->
    {
      totalTodo:Ember.String.htmlSafe("width: #{@get('totalTodoPercent')}%")
      inprogress:Ember.String.htmlSafe("width: #{@get('inprogressPercent')}%")
      translated:Ember.String.htmlSafe("width: #{@get('translatedPercent')}%")
      totalReviewed:Ember.String.htmlSafe("width: #{@get('totalReviewedPercent')}%")
      confirmed:Ember.String.htmlSafe("width: #{@get('confirmedPercent')}%")
    }
  userObserver: Ember.observer 'language', 'user.poetryTask', 'config.taxonomy.id', ( ->
    interestingForObserver = @get 'config.taxonomy.id'
    if @get 'language'
      @get('user.poetryTask').then (poetry) =>
        @fetchTasks()
  ).on('init')
  fetchTasks: (schedule) ->
    poetryId = @get('poetryTask.id')
    if poetryId
      kpi = "992c2ebb-1d2a-4929-a732-d6a8e7d02545" # kpi scoped to poetry task
    else
      kpi = "c806ab0d-e146-423c-8e41-13258f2b0d27" # general kpi

    scheme = @get 'config.taxonomy.id'
    if @get 'language'
      promise = Ember.$.getJSON "/kpis/#{kpi}/run?kpi-language=#{@get('language')}&kpi-scheme=#{scheme}&kpi-poetryId=#{poetryId}"
      promise.then( (result) =>
        observations = result.data.relationships.observations.data
        @set 'lastFetched', Date.now()
        @set 'todo', 0
        @set 'conceptupdated', 0
        @set 'inprogress', 0
        @set 'translated', 0
        @set 'reviewedwithoutcomments', 0
        @set 'reviewedwithcomments', 0
        @set 'confirmed', 0
        observations.forEach (obs) =>
          @set `obs.attributes.status.replace(/ /g, '')`, obs.attributes.total
      if schedule
        Ember.run.later(@fetchTasks, 60000)
    )
`export default UserTasksService`
