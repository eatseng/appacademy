GistApp.Views.GistFormView = Backbone.View.extend({
  initialize: function() {},

  events: {
    "click #submit" : "submit"
  },

  template: JST['gists/gist_form'],

  render: function() {
    var renderedContent = this.template();

    this.$el.html(renderedContent);
    return this;
  },

  submit: function(event) {
    var title = $('#gistTitle').val();
    var gist = new GistApp.Models.Gist();
    gist.set({title: title});
    gist.save({
      success: function() {
        debugger
      }
    });
  }
});