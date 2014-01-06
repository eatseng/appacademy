(function (root) {
  var Asteroids = root.Asteroids = (root.Asteroids || {});

  Function.prototype.inherits = function (otherClass) {
    function Surrogate () {};
    Surrogate.prototype = otherClass.prototype;
    this.prototype = new Surrogate();
  };
})(this);