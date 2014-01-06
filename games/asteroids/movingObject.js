(function(root) {
  var Asteroids = root.Asteroids = (root.Asteroids || {});

  var MovingObject = Asteroids.MovingObject = function (pos, vel, radius, color) {
    this.pos = [];
    this.pos[0] = pos[0];
    this.pos[1] = pos[1];
    this.vel = [];
    this.vel[0] = vel[0];
    this.vel[1] = vel[1];
    this.radius = radius;
    this.color = color;
  };

  MovingObject.prototype.move = function () {
    this.pos[0] += this.vel[0];
    this.pos[1] += this.vel[1];
  };

  MovingObject.prototype.draw = function (ctx) {
    ctx.fillStyle = this.color;
    
    ctx.beginPath();
    ctx.arc(
      this.pos[0],
      this.pos[1],
      this.radius,
      0,
      2*Math.PI,
      false
      );
    ctx.closePath();

    ctx.fill();
  };

  MovingObject.prototype.isCollideWith = function (object) {
    return ((Math.pow((this.pos[0] - object.pos[0]), 2) + 
            Math.pow((this.pos[1] - object.pos[1]), 2)) <= 
            Math.pow((this.radius + object.radius), 2)
            );
  };
})(this);