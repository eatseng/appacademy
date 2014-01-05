(function (root) {
	var Snakes = root.Snakes = (root.Snakes || {});

	var View = Snakes.View = function () {}

	View.FPS = 5;

	View.prototype.start = function() {
		this.board = new Snakes.Board();
		this.setTile();

		$(document).keydown(handleKeyEvent.bind(this));
		this.timerId = setInterval(this.step.bind(this), 1000/View.FPS);
	}

	View.prototype.step = function() {
		this.board.snake.move();
		this.board.snakeEatApple()
		if (!this.board.validMove()) {
			clearInterval(this.timerId);
			alert("Game Over!");
			return;
		}
		this.render();
	}

	View.prototype.setTile = function() {
		for(var i = 0; i < Snakes.Board.DIMENSION*Snakes.Board.DIMENSION; i++){
			if(i % Snakes.Board.DIMENSION == 0 && i != 0) {
				$('body').append('<br  />');	
			}
				$('body').append('<div class="empty" data-id=' + i + '></div>');
		}
	}

	View.prototype.resetTile = function() {
		$('div').removeClass('snake');
		$('div').removeClass('apple');
	}

	View.prototype.render = function() {
		var snake = this.board.snake.segments;
		this.resetTile();
		
		for (var i = 0; i < snake.length; i++) {
			var id = snake[i].i * Snakes.Board.DIMENSION + snake[i].j;
			$('.empty').eq(id).addClass("snake");
		}

		for (var i = 0; i < this.board.apple.length; i++) {
			var id = this.board.apple[i].coords.i * Snakes.Board.DIMENSION + this.board.apple[i].coords.j;
			$('.empty').eq(id).addClass("apple");
		}
	}

	handleKeyEvent = function(event){
		var pressedKey = event.keyCode;
		switch(pressedKey){
		case 65:
			this.board.snake.turn("e");
			break;
		case 83:
			this.board.snake.turn("s");
			break;
		case 68:
			this.board.snake.turn("w");
			break;
		case 87:
			this.board.snake.turn("n");
			break;
		}
	}

})(this);