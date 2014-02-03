window.GistApp = {
  Models: {},
  Collections: {},
  Routers: {},
  Views: {},

  initialize: function() {
    var $rootEl = $('#content');
    var $rootSi = $('#sidebar');
    var gists = new GistApp.Collections.Gists();
    var gistForm = new GistApp.Views.GistFormView($rootSi);
    $rootSi.html(gistForm.render().$el);

    gists.fetch({
      success: function () {
        new GistApp.Routers.Router(gists, $rootEl);
        Backbone.history.start();
      }
    });
  }
};


$(function () {
  GistApp.initialize();
});