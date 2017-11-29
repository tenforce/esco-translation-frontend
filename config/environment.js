/* jshint node: true */

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'translation-frontend',
    environment: environment,
    baseURL: '/esco/translation',
    locationType: 'auto',
    contentSecurityPolicy: {
      'default-src': "'none'",
      'script-src': "'self'",
      'font-src': "'self'",
      'connect-src': "'self' *",
      'img-src': "'self'",
      'style-src': "'self' 'unsafe-inline' *",
      'media-src': "'self'"
    },
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      }
    },
    filters: {
      withoutPoetry: {
        id: "70d7bd9f-107a-40dd-91f7-9bd210b7e7fc",
        variables: ['language', 'status']
      },
      withPoetry: {
        id:"3ee71d81-7e56-4742-a422-40a39a826421",
        variables: ['status', 'language', 'poetry']
      },
      withPoetryNoStatus: {
        id: "d8ce62a2-e6e8-42aa-940e-9016c9144351",
        variables: ['language', 'poetry']
      }
    },
    // list of statuses, array because the order is important
    statuses: [
      { id: "all", name: "All", explained: "Show concept in any status" },
      { id: "concept updated", name: "Concept updated", explained: "This concept has been updated" },
      { id: "to do", name: "To do", explained: "This concept has not yet been translated" },
      { id: "in progress", name: "In progress", explained: "This concept is being translated" },
      { id: "translated", name: "Translated", explained: "This concept has been translated" },
      { id: "reviewed without comments", name: "Reviewed without comments", explained: "This concept was reviewed without comments" },
      { id: "reviewed with comments", name: "Reviewed with comments", explained: "This concept was reviewed with comments" },
      { id: "confirmed", name: "Confirmed", explained: "This concept has been confirmed" }
    ],

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    },
    validationTimeOut: 60 ,
    translation: {
      occupationScheme: '6b73f82c-2543-4a72-a86d-e988869df5ca',
      skillScheme: 'c61aced6-0285-4da5-aa9e-ef09ba364f6e',
      defaultLanguage: 'en',
      instanceTitle: 'Translation Platform Demo',
      /*disableTaxonomyChange: true,*/
      disableTaxonomyChange: false,
      /*tooltipTaxonomyChange: "Switch taxonomies disabled, Skills are being implemented",*/
      tooltipTaxonomyChange: "Click to switch the taxonomy to be translated"
    }
  };

  if (environment === 'development') {
    ENV.baseURL = '/';
    locationType= 'auto';
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.baseURL = '/';
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
  }

  if (environment === 'production') {

  }
  ENV['ember-simple-auth'] = {
    authenticationRoute: 'sign-in',
    routeAfterAuthentication: 'index'
  };

  return ENV;
};

