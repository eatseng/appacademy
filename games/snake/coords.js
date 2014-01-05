(function (root){
	var Snakes = root.Snakes = ( root.Snakes || {} );

	var Coords = Snakes.Coords = function (i, j) {
    this.i = i;
    this.j = j;
  };

	Coords.prototype.plus = function(coords2) {
		return new Coords(this.i + coords2.i, this.j + coords2.j);
	};

  Coords.prototype.isEqual = function(coords2) {
    return (this.i == coords2.i && this.j == coords2.j);
  };

  Coords.random = function () {
    return new Coords(Math.floor(Math.random()*(Snakes.Board.DIMENSION)),
      Math.floor(Math.random()*(Snakes.Board.DIMENSION)));
  };

})(this);