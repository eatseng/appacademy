GistApp.Routers.Router = Backbone.Router.extend({
  initialize: function(gists, $rootEl) {
    this.gists = gists;
    this.$rootEl = $rootEl;
  },

  routes: {
    "" : "index",
    "gists/:gist_id" : "show"
  },

  index: function(gists) {
    var indexView = new GistApp.Views.GistsIndexView({
      collection: this.gists
    });

    this._swapView(indexView);
  },

  show: function(gist_id) {
    var detailView = new GistApp.Views.GistDetailView({
      model: this.gists.get(gist_id)
    });

    this._swapView(detailView);
  },


  _swapView: function (view) {
    this._current_view && this._current_view.remove();
    this._current_view = view;
    this.$rootEl.html(view.render().$el);
  }
});