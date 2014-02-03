GistApp.Models.Gist = Backbone.Model.extend({
  urlRoot: '/gists',

  parse: function (data) {
    if (data.favorite) {

      data.favorite = new GistApp.Models.Favorite(data.favorite);

    }
    return data;
  },

  toJson: function() {
    var data = _.clone(this.attributes);
    data.unset('favorite');
    return data;
  }

});