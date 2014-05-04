@Linkando.module "LandingApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "landing_page/show/show_layout"

    regions:
      landingRegion: "#landing-region"



  class Show.Landing extends App.Views.ItemView
    template: "landing_page/show/_landing"

    events:
      "keydown" : 'strokeDetector'

    strokeDetector: (e) =>
      # model = @.model
      if (e.keyCode ==32 || e.keyCode ==13 )
        $.ajax '/url',
          type: 'POST'
          dataType: 'json'
          data: { url: $("input").val() }


  #
  # share: ->
  #   e.preventDefault();
  #   var url = $(e.currentTarget).attr('href');
  #   this.openPopup(url, 600, 300);
  #
  # openPopup: (url, width, height)  ->
  #   var left = (window.screen.width / 2) - ((width / 2) + 10)
  #   var top = (window.screen.height / 2) - ((height / 2) + 50)
  #   window.open(url, "ShareStremeWindow", "status=no,height=" + height + ",width=" + width + ",resizable=yes,left=" + left + ",top=" + top + ",screenX=" + left + ",screenY=" + top + ",toolbar=no,menubar=no,scrollbars=no,location=no,directories=no")
