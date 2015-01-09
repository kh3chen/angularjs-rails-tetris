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
  top       # Add to cell row (i)
  left      # Add to cell col (j)

  cells: [] # This is relative to the box

  constructor: ->

  lRotate: ->
    #code
  rRotate: ->
    #code

  iBlock: ->
    top = 0.5
    left = 4.5
    cells =
      [ [-0.5, -1.5],
        [-0.5, -0.5],
        [-0.5, 0.5],
        [-0.5, 1.5] ]
    # ______
    # |    |
    # |####|
    # |    |
    # |    |
    # ------

  jBlock: ->
    top = 0
    left = 4
    cells =
      [ [0, -1],
        [0, 0],
        [0, 1],
        [1, 1] ]
    # _____
    # |   |
    # |###|
    # |  #|
    # -----

  lBlock: ->
    top = 0
    left = 4
    cells =
      [ [0, -1],
        [0, 0],
        [0, 1],
        [1, -1] ]
    # _____
    # |   |
    # |###|
    # |#  |
    # -----

  oBlock: ->
    top = 0.5
    left = 4.5
    cells =
      [ [-0.5, -0.5],
        [-0.5, 0.5],
        [0.5, -0.5],
        [0.5, 0.5] ]
    # ____
    # |##|
    # |##|
    # ----

  sBlock: ->
    top = 1
    left = 4
    cells =
      [ [-1, 0],
        [-1, 1],
        [0, -1],
        [0, 0] ]
    # _____
    # | ##|
    # |## |
    # |   |
    # -----

  tBlock: ->
    top = 0
    left = 4
    cells =
      [ [0, -1],
        [0, 0],
        [0, 1],
        [1, 0] ]
    # _____
    # |   |
    # |###|
    # | # |
    # -----

  zBlock: ->
    top = 1
    left = 4
    cells =
      [ [-1, -1],
        [-1, 0],
        [0, 0],
        [0, 1] ]
    # _____
    # |## |
    # | ##|
    # |   |
    # -----
