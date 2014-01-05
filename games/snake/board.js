(function(root){
	var Snakes = root.Snakes = ( root.Snakes || {} );

	var Board = Snakes.Board = function () {
		this.snake = new Snakes.Snake("n",
			[new Snakes.Coords(5,5), new Snakes.Coords(5,6), new Snakes.Coords(5,7)]);	
		this.apple = [new Snakes.Apple()];
	};

	Board.DIMENSION = 10;

	Board.prototype.validMove = function () {
		for (var i = 0; i < this.snake.segments.length; i++) {
			for (var j = 0; j < this.snake.segments.length; j++) {
				if (this.snake.segments[i].isEqual(this.snake.segments[j]) && i != j) {
					return false;
				}
			}
		}
		return (this.snake.segments[0].i >= 0 && this.snake.segments[0].i < Snakes.Board.DIMENSION) &&
			(this.snake.segments[0].j >= 0 && this.snake.segments[0].j < Snakes.Board.DIMENSION);
	};

	Board.prototype.generateApple = function () {
		this.apple.push(new Snakes.Apple());
	};

	Board.prototype.snakeEatApple = function () {
		for (var i = 0; i < this.apple.length; i++) {
			for (var j = 0; j < this.snake.segments.length; j++) {
				if (this.snake.segments[j].isEqual(this.apple[i].coords))	{
					this.apple.shift();
					this.generateApple();
					this.snake.segments.push(this.snake.growSeg);
				}
			}
		}
	};

})(this); 