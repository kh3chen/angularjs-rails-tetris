angular.module('tetris-model', [])

.factory('Game', [
  'Grid', 'Block'
  (Grid, Block)->
    class Game
      constructor: ->
        @reset()

      reset: ->
        @grid = new Grid
        @block = new Block @grid
        @linesCleared = 0
        @gameState = 0
        # 0: New game, game inactive
        # 1: Generate block, check if the newly generated block collides with anything
        # 2: Game over state

      generateBlock: ->
        rand = Math.random(7)
        switch rand
        # Keyword usage error on case. Lookup switch & case on CoffeeScript
          when 0 then @block.iBlock()
          when 1 then @block.jBlock()
          when 2 then @block.lBlock()
          when 3 then @block.oBlock()
          when 4 then @block.sBlock()
          when 5 then @block.tBlock()
          when 6 then @block.zBlock()

      moveBlock: ->

    return Game

])

.factory('Grid', [
  ()->
    class Grid

      constructor: ->
        @cells = []
        for i in [0..21]
          @cells.push([])
          for j in [0..9]
            @cells[i].push(' ')

      drawText: ->
        rowText = '\t------------\n'
        for i in [0..21]
          rowText += '\t|'
          for j in [0..9]
            rowText += @cells[i][j]
          rowText += '|\n'
        rowText += '\t------------\n'
        rowText

      getCell: (row, column) ->
        @cells[row][column]

      setCell: (row, column, value) ->
        @cells[row][column] = value

    return Grid
])

.factory('Block', [
  'Grid',
  (Grid)->
    class Block

      constructor: (@grid) ->
        @top = 0      # Add to cell row (i)
        @left = 0     # Add to cell col (j)
        @cells = []   # This is relative to the box


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
    return Block
])
