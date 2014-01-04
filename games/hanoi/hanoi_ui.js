(function (root) {
  var Hanoi = root.Hanoi = (root.Hanoi || {});

	var UI = Hanoi.UI = function(game) {
		this.game = game;
	};

	UI.prototype.initialize = function() {
		var that = this;
		var clicked = false;
		var fromTower;
		this.setTiles();
		this.printTowers();

		$('.tile').on('click', function(event){
			if(!clicked){
				clicked = true;
				var towerIndex = $(event.target).data('id');
				fromTower = that.tileMapping(towerIndex);
				$('.prompt1').text("Selected from-Tower: " + fromTower)
				$('.prompt2').text("Selected to-Tower: ")
			} else {
				clicked = false;
				var towerIndex = $(event.target).data('id');
				var toTower = that.tileMapping(towerIndex);
				$('.prompt1').text("Selected from-Tower: " + fromTower)
				$('.prompt2').text("Selected to-Tower: " + toTower)
				if (that.game.isValidMove(fromTower, toTower)) {
					that.game.move(fromTower, toTower);
					that.printTowers();
				} else {
					alert("Invalid Move!!")
				}
				if(game.isWon()){
					alert("Game Win!");
				}
			}
		});
	};

	UI.prototype.setTiles = function () {
		$('body').append('<div class="title">Tower of Hanoi</div><br />');
		for (var i = 0; i < 9; i++) {
			if (i % 3 == 0 && i != 0) {
				$('body').append('<br  />');
			}
			$('body').append('<div class="tile" data-id=' + i + '></div>');
		}
		
		$('body').append('<br  />');
		for (var i = 0; i < 3; i++) {
			$('body').append('<div class="label">Tower ' + i + '</div');
		}

		$('body').append('<br  /><div class="display1"></div><br  />');
		$('body').append('<div class="display2"></div>');
		$('.display1').append('<h2 class="prompt1">Selected from-Tower:</h2>');
		$('.display2').append('<h2 class="prompt2">Selected to-Tower:</h2>');
	};

	UI.prototype.resetTiles = function () {
		$('.tile').removeClass('onePiece');
		$('.tile').removeClass('twoPiece');
		$('.tile').removeClass('threePiece');
	}

	UI.prototype.tileMapping = function(num) {
		var output = [0, 1, 2, 0, 1, 2, 0, 1, 2];
		return output[num];
	};

	UI.prototype.printTowers = function() {
		var towers = this.game.returnTowers();
		var towerMap = [[6, 3, 0], [7, 4, 1], [8, 5, 2]];

		this.resetTiles()

		for (var i = 0; i < towers.length; i++) {
			for (var j = 0; j < towers[i].length; j++) {
				switch (towers[i][j]) {
					case 1: 
						$('.tile').eq(towerMap[i][j]).addClass('onePiece');
						break;
					case 2:
						$('.tile').eq(towerMap[i][j]).addClass('twoPiece');
						break;
					case 3:
						$('.tile').eq(towerMap[i][j]).addClass('threePiece');
						break;
				}
			}
		}
	};

})(this);