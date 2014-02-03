GistApp.Views.GistsIndexView = Backbone.View.extend({
  initialize: function() {
    this.listenTo(this.collection, 'sync', this.render);
  },

  events: {
    "click .favorite" : "addFavorite",
    "click .unfavorite" : "removeFavorite"
  },

  template: JST['gists/index'],

  render: function() {
    console.log("rendering");
    var renderedContent = this.template({
      collection: this.collection
    });
    this.$el.html(renderedContent);
    return this;
  },

  addFavorite: function(event) {
    var that = this;
    var favorite = new GistApp.Models.Favorite();
    favorite.set({gist_id: $(event.currentTarget).attr('data-id')});
    favorite.save({}, {
      success: function(object) {
        debugger
        that.render();
      }
    });
  },

  removeFavorite: function(event) {
    var that = this;
    var favorite = new GistApp.Models.Favorite();
    favorite.set({id: $(event.currentTarget).attr('id')});
    favorite.set({gist_id: $(event.currentTarget).attr('gist_id')});
    favorite.destroy({}, {
      success:function(){
        that.render();
      }
    });
  }
});