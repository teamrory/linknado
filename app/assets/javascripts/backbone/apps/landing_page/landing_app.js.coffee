@Linkando.module "LandingApp", (LandingApp, App, Backbone, Marionette, $, _) ->

  class LandingApp.Router extends Marionette.AppRouter
    appRoutes:
      "connect" : "show"


  API =
    show: ->
      new LandingApp.Show.Controller



  App.addInitializer ->
    new LandingApp.Router
      controller: API
