(function (root) {
  var Asteroids = root.Asteroids = (root.Asteroids || {});

  var Ship = Asteroids.Ship = function (pos, vel) {
    Asteroids.MovingObject.call(this, pos, vel, Ship.RADIUS, Ship.COLOR);
    this.pos = pos;
    this.vel = vel;
  };

  Ship.inherits(Asteroids.MovingObject);

  Ship.RADIUS = 10;
  Ship.COLOR = 'red';

  Ship.prototype.powerUp = function () { 
    if (this.vel[1] >= -2) { this.vel[1] -=2; }
  };
  Ship.prototype.powerDown = function () { 
    if (this.vel[1] <= 2) { this.vel[1] +=2; }
  };
  Ship.prototype.powerLeft = function () {
    if (this.vel[0] >= -2) { this.vel[0] -=2; }
  };
  Ship.prototype.powerRight = function () { 
    if (this.vel[0] <= 2) { this.vel[0] +=2; }
  };
  
  Ship.prototype.fireBullet = function () {
    if (this.vel[0] != 0 || this.vel[1] != 0) {
      return new Asteroids.Bullet(this.pos, this.vel);
    } 
  };
})(this);