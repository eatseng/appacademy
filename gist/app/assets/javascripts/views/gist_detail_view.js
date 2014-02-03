GistApp.Views.GistDetailView = Backbone.View.extend({
  template: JST['gists/gist_detail'],

  render: function () {
    var renderedContent = this.template({
      model: this.model
    });

    this.$el.html(renderedContent);
    return this;
  }


});