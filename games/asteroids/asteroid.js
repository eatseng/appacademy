(function(root) {
  var Asteroids = root.Asteroids = (root.Asteroids || {});

  var Asteroid = Asteroids.Asteroid = function (pos, vel) {
    Asteroids.MovingObject.call(this, pos, vel, Asteroid.RADIUS, Asteroid.COLOR);
  };

  Asteroid.inherits(Asteroids.MovingObject);

  Asteroid.COLOR = 'black';
  Asteroid.RADIUS = 20;
  Asteroid.VEL = 3;

  var randomVec = function () {
    if (Math.random() < 0.5) {
      return randomPos(-Asteroid.VEL, Asteroid.VEL);
    } else {
      return randomPos(Asteroid.VEL, Asteroid.VEL);
    }
  };

  var randomPos = function (x, y) {
    return [Math.random() * x, Math.random() * y];
  };

  Asteroid.randomAsteroid = function (dimX, dimY) {
    return new Asteroid (randomPos(dimX, dimY), randomVec());
  };

  
})(this);
