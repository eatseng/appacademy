(function (root) {
  var TTT = root.TTT = (root.TTT || {});

	var UI = TTT.UI = function(game) {
		this.game = game;
	};

	UI.prototype.initialize = function() {
		var that = this;
		var playerX = true;
		this.setTitle();
		this.setTiles();

		$('.tile').on('click', function(event){
			var targetId = $(event.target).data('id');
			var playerMove = that.tileMapping(targetId);
			if (that.game.valid(playerMove)) {
				that.game.move(playerMove);
				if (playerX) {
					playerX = false;
					$('.tile').eq(targetId).addClass('xPiece');
					$('.prompt').eq(targetId).text("X");
				} else {
					playerX = true;
					$('.tile').eq(targetId).addClass('oPiece');
					$('.prompt').eq(targetId).text("O");
				}
				var winner = that.game.winner();
				if(winner){
					alert("Player " + winner + " Wins");
				}
			} else {
				alert ("Invalid Move!");
			}
		});
	}

	UI.prototype.setTitle = function() {
		$('body').append('<div class="title"></div>');
		$('div').append('<h1 class="title-txt">Tic Tac Toe</h1>');
		$('body').append('<br  />');		
	}

	UI.prototype.setTiles = function() {
		for (var i = 0; i < 9; i++) {
			if (i % 3 == 0 && i != 0) {
				$('body').append('<br  />');
			}
			$('body').append('<div class="tile" data-id=' + i + '></div>');
			$('.tile').eq(i).append('<h2 class="prompt" data-id=' + i + '></h2>');
		}
	};

	UI.prototype.tileMapping = function(num) {
		var output = [[0,0], [0,1], [0,2], [1,0], [1,1], [1,2], [2,0], [2,1],[2,2]];
		return output[num];
	};
})(this);