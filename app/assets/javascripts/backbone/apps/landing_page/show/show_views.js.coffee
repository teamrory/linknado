@Linkando.module "LandingApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "landing_page/show/show_layout"

    regions:
      landingRegion: "#landing-region"



  class Show.Landing extends App.Views.ItemView
    template: "landing_page/show/_landing"
