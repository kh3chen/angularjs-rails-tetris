tetris = angular.module('tetris',[])

tetris.controller('tetrisCtrl', ($scope) ->  #, Grid, Cell, Block
  $scope.greeting = 'Hello'
  $scope.recipient = 'You'
)
 

class Cell
  value: ' '

  constructor: (@row, @column) ->

# Values should be one of ' ', I, S, Z, O, L, J, T
  getValue: ->
    @value

  setFilled: (@filled) ->

class Grid
  cells: []

  constructor: ->
    for i in [0..21]
      @cells.push([])
      for j in [0..9]
        @cells[i].push( new Cell(i, j) )

  draw: ->
    rowText = ''
    for i in [0..21]
      for j in [0..9]
        rowText += cells[i][j]
      console.log(rowText)

  getCell: (row, column) ->
    @cells[row][column]

# We will have exactly one instance of this at a time. This is our active moveable block.
class Block
  top       # Add to cell row (i)
  left      # Add to cell col (j)

  cells: [] # This is relative to the box

  constructor: ->

  moveLeft: ->
    # Check if left is a viable move
    # Write code here
    for i in [0..3]
      if (left-1 + cells[0] is already_occupied)
        return false
    left--
    true

  moveRight: ->
    # Check if left is a viable move
    # Write code here
    for i in [0..3]
      if (left+1 + cells[0] is already_occupied)
        return false
    left++
    true

  moveDown: ->
    # Check if left is a viable move
    # Write code here
    for i in [0..3]
      if (top+1 + cells[0] is already_occupied)
        return false
    top++
    true

  lRotate: ->
    for i in [0..3]
      # (x, y) => (-y, x)
      tmp = @cells[i][0]
      @cells[i][0] = @cells[i][1] * -1
      @cells[i][1] = tmp
  rRotate: ->
    for i in [0..3]
      # (x, y) => (y, -x)
      tmp = @cells[i][1]
      @cells[i][1] = @cells[i][0] * -1
      @cells[i][0] = tmp

  getCells: ->
    absCells: [ [], [] ]
    for i in [0..3]
      absCells[i].push(top + cells[i][0])
      absCells[i].push(left + cells[i][1])
    absCells

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

class Game
  grid
  block
  gameState
  linesCleared

  constructor: ->
    @reset()

  reset: ->
    @grid = new Grid()
    gameState = 0
    linesCleared = 0

  getGridText: ->
    gridText = ""
    absCells = @grid.getCells()
    for i in [0..21]
      for j in [0..9]
        gridText += absCells[i][j]
      gridText += "\n"
    gridText

  generateBlock: ->
    rand = Math.random(7)
    switch
      case 0:
        block.iBlock()
        break
      case 1:
        block.jBlock()
        break
      case 2:
        block.lBlock()
        break
      case 3:
        block.oBlock()
        break
      case 4:
        block.sBlock()
        break
      case 5:
        block.tBlock()
        break
      case 6:
        block.zBlock()
        break


