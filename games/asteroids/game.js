(function(root){
  var Asteroids = root.Asteroids = (root.Asteroids || {});

  var Game = Asteroids.Game = function (canvas) {
    this.ctx = canvas.getContext('2d');
    this.asteroids = Game.addAsteroids(Game.NUMAST);
    this.ship = new Asteroids.Ship([Game.DIMX / 2, Game.DIMY/2], [0, 0]);
    this.bullets = [];
    this.bullet_cnt = 0;
    this.score = 0;
  };

  Game.NUMAST = 20;
  Game.DIMX = 800;
  Game.DIMY = 400;
  Game.FPS = 30;

  Game.addAsteroids = function (numAsteroids) {
    var asteroids = [];
    for (var i = 0; i < numAsteroids; i++) {
      asteroids.push(Asteroids.Asteroid.randomAsteroid(Game.DIMX, Game.DIMY));
    }
    return asteroids;
  };

  Game.prototype.draw = function () {
    var that = this;
    var objects = this.asteroids.concat(this.ship).concat(this.bullets);
    this.ctx.clearRect(0, 0, Game.DIMX, Game.DIMY);
    this.ctx.rect(0,0, Game.DIMX, Game.DIMY);
    this.ctx.stroke();
    
    objects.forEach(function (object) {
      object.draw(that.ctx);
    });
  };

  Game.prototype.move = function () {
    var objects = this.asteroids.concat(this.ship).concat(this.bullets);

    objects.forEach(function (object) {
      object.move();
    });
  };

  Game.prototype.step = function () {
    this.removeOutBound(this.bullets);
    this.move();
    this.respawn();
    this.draw();
    this.checkCollisions();
    this.hitAsteroids();
    this.printScore();
  };

  Game.prototype.start = function () {
    this.bindKeyHandler();
    this.intervalId = setInterval( this.step.bind(this), 1000/Game.FPS );
  };

  Game.prototype.stop = function () {
    clearInterval(this.intervalId);
  };

  Game.prototype.checkCollisions = function () {
    var that = this;
    var objects = this.asteroids;

    objects.forEach(function (object) {
      if (object.isCollideWith(that.ship)) {
        alert("Game Over!");
        that.stop();
      }
    });
  };

  Game.prototype.bindKeyHandler = function () {
    var that = this;
    key('w', function(){ that.ship.powerUp(); });
    key('s', function(){ that.ship.powerDown(); });
    key('a', function(){ that.ship.powerLeft(); });
    key('d', function(){ that.ship.powerRight(); });
    key('f', function(){ 
      var bullet = that.ship.fireBullet();
      if (bullet) { 
        that.bullets.push(bullet); 
        that.bullet_cnt++;
      }
    });
  };

  Game.prototype.respawn = function () {
    var that = this;
    var objects = this.asteroids.concat(this.ship);
    
    objects.forEach(function (object) {
      if (object.pos[0] + object.radius < 0) 
        {object.pos[0] += (Game.DIMX + object.radius);}
      if (object.pos[0] - object.radius > Game.DIMX) 
        {object.pos[0] -= (Game.DIMX + object.radius);}
      if (object.pos[1] + object.radius < 0) 
        {object.pos[1] += (Game.DIMY + object.radius);}
      if (object.pos[1] - object.radius > Game.DIMY) 
        {object.pos[1] -= (Game.DIMY + object.radius);}
    });
  };

  Game.prototype.isOutOfBound = function (object) {
      if (object.pos[0] + object.radius < 0) {return true;}
      else if (object.pos[0] - object.radius > Game.DIMX) {return true;} 
      else if (object.pos[1] + object.radius < 0) {return true;}
      else if (object.pos[1] - object.radius > Game.DIMY) {return true;}
      else {return false;}
  };

  Game.prototype.removeOutBound = function (objects) {
    for (var i = 0; i < objects.length; i++) {
      if (this.isOutOfBound(objects[i])) { objects.splice(i, 1); }
    }
  };

   Game.prototype.hitAsteroids = function () {
    var bullets = [];
    var asteroids = [];
    for (var i = 0; i < this.bullets.length; i++) {
      for (var j = 0; j < this.asteroids.length; j++) {
        if(this.bullets[i].isCollideWith(this.asteroids[j])) {
          bullets.push(i);
          asteroids.push(j);
          this.score++;
        }
      }
    }

    var that = this;
    bullets.forEach(function(index) { that.bullets.splice(index, 1); });
    asteroids.forEach(function(index) { that.asteroids.splice(index, 1); });
  };

  Game.prototype.printScore = function () {
    var accuracy = (this.score/this.bullet_cnt).toFixed(2);
    $('.title').text("Asteroids");
    $('.score').text("Score: " + this.score);
    $('.acc').text("Accuracy: " + accuracy*100 + " %");
  };

})(this);