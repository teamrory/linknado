@Linkando.module "LandingApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Application

    initialize: ->
      @layout = @getLayoutView()

      @listenTo @layout, "show", =>
        @landingRegion()

      @show @layout, loading: true


    landingRegion: ->
      landingView = @getLandingView()

      @layout.landingRegion.show landingView


    getLandingView: ->
      new Show.Landing


    getLayoutView: ->
      new Show.Layout
