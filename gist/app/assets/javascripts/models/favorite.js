GistApp.Models.Favorite = Backbone.Model.extend({
  url: function() {
    if (this.get('id')) {
      return "gists/" + this.get('gist_id') + "/favorites/" + this.get('id');
    } else {
      return "gists/" + this.get('gist_id') + "/favorites/";
    }
  },
  urlRoot: function() {
    return "gists/" + this.get('gist_id') + "/favorites";
  }
});