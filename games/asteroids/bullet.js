(function(root) {
  var Asteroids = root.Asteroids = (root.Asteroids || {});

  var Bullet = Asteroids.Bullet = function (pos, vel) {
    Asteroids.MovingObject.call(this, pos, vel, Bullet.RADIUS, Bullet.COLOR);
    this.vel = calcVel(vel);
  };

  Bullet.inherits(Asteroids.MovingObject);

  Bullet.RADIUS = 5;
  Bullet.COLOR = 'orange';
  Bullet.SPD = 5;

  var calcVel = function (vel) {
    var xRatio = vel[0] / (Math.abs(vel[0]) + Math.abs(vel[1]));
    var yRatio = vel[1] / (Math.abs(vel[0]) + Math.abs(vel[1]));
    var sumComp = Math.sqrt(Math.pow(Bullet.SPD, 2) / 
                  (Math.pow(xRatio, 2) + Math.pow(yRatio, 2)));

    return [sumComp * xRatio, sumComp * yRatio];
  };

})(this);