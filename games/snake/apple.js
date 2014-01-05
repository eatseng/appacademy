(function(root) {
  var Snakes = root.Snakes = (root.Snakes || {});

  var Apple = Snakes.Apple = function () {
    this.coords = Snakes.Coords.random();
  };
})(this);