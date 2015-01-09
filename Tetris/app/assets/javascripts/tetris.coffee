tetris = angular.module('tetris',[
]);

class Cell
  constructor: (@row, @column) ->

# Values should be one of ' ', I, S, Z, O, L, J, T
  getValue: ->
    value

  setFilled: (@filled) ->

class Grid
  constructor: ->
    for i in [0..21]
      for j in [0..9]
        cells[i][j] = new Cell(i, j)
