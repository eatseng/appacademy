(function (root){
	var Snakes = root.Snakes = ( root.Snakes || {} );

	var Snake = Snakes.Snake = function (dir, segments){
		this.dir = dir;
		this.segments = segments;
		this.growSeg = segments[segments.length - 1];
	};

	Snake.MOVEMENT = {
		"n" : new Snakes.Coords(-1, 0),
		"s" : new Snakes.Coords(1, 0),
		"e" : new Snakes.Coords(0, -1),
		"w" : new Snakes.Coords(0, 1)
	};

	Snake.prototype.move = function() {
		var nextSeg = this.segments[0].plus(Snake.MOVEMENT[this.dir]);
		this.segments.unshift(nextSeg);
		this.growSeg = this.segments.pop();
	};

	Snake.prototype.turn = function(dir) {
		this.dir = dir;
	};
})(this)