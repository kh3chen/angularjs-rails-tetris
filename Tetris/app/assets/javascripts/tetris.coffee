tetris = angular.module('tetris',[
]);

class Cell
  value: ' '

  constructor: (@row, @column) ->

# Values should be one of ' ', I, S, Z, O, L, J, T
  getValue: ->
    value

  setFilled: (@filled) ->

class Grid
  cells: []

  constructor: ->
    for i in [0..21]
      for j in [0..9]
        cells[i][j] = new Cell(i, j)

  draw: ->
    rowText = ''
    for i in [0..21]
      for j in [0..9]
        rowText += cells[i][j]
      console.log(rowText)

  getCell: (row, column) ->
    cells[row][column]

# We will have exactly one instance of this at a time. This is our active moveable block.
class Block
  boxLeft
  boxTop
  boxSize
  cells: [] # This is relative to the box

  constructor: ->

  lRotate: ->
    #code
  rRotate: ->
    #code

  iBlock: ->
    boxTop = 0
    boxLeft = 3
    boxSize = 4
    cells =
      [ [1, 0],
        [1, 1],
        [1, 2],
        [1, 3] ]
    # ______
    # |    |
    # |####|
    # |    |
    # |    |
    # ------

  jBlock: ->
    boxTop = 0
    boxLeft = 3
    boxSize = 3
    cells =
      [ [0, 0],
        [1, 0],
        [1, 1],
        [1, 2] ]
    # _____
    # |#  |
    # |###|
    # |   |
    # -----

  lBlock: ->
    boxTop = 0
    boxLeft = 3
    boxSize = 3
    cells =
      [ [0, 3],
        [1, 0],
        [1, 1],
        [1, 2] ]
    # _____
    # |  #|
    # |###|
    # |   |
    # -----

  oBlock: ->
    boxTop = 0
    boxLeft = 4
    boxSize = 2
    cells =
      [ [0, 0],
        [0, 1],
        [1, 0],
        [1, 1] ]
    # ____
    # |##|
    # |##|
    # ----

  sBlock: ->
    boxTop = 0
    boxLeft = 3
    boxSize = 3
    cells =
      [ [0, 1],
        [0, 2],
        [1, 0],
        [1, 1] ]
    # _____
    # | ##|
    # |## |
    # |   |
    # -----

  tBlock: ->
    boxTop = 0
    boxLeft = 3
    boxSize = 3
    cells =
      [ [0, 1],
        [1, 0],
        [1, 1],
        [1, 2] ]
    # _____
    # | # |
    # |###|
    # |   |
    # -----

  zBlock: ->
    boxTop = 0
    boxLeft = 3
    boxSize = 3
    cells =
      [ [0, 0],
        [0, 1],
        [1, 1],
        [1, 2] ]
    # _____
    # |## |
    # | ##|
    # |   |
    # -----
