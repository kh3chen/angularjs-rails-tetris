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

      start: ->
        @block.generateBlock()

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

      setCells: (cells, value) ->
        for c in cells
          @cells[cells[0]][cells[1]] = value

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

       generateBlock: ->
        rand = Math.floor(Math.random()*7)
        console.log('generateBlock rand: ' + rand)
        switch rand
        # Keyword usage error on case. Lookup switch & case on CoffeeScript
          when 0 then @iBlock()
          when 1 then @jBlock()
          when 2 then @lBlock()
          when 3 then @oBlock()
          when 4 then @sBlock()
          when 5 then @tBlock()
          when 6 then @zBlock()


      move: (newCells) ->
        oldCells = @getAbsCells(@top, @left, @cells)
        for oc in oldCells
          console.log(oc[0] + ' ' + oc[1])
          @grid.setCell(oc[0], oc[1], ' ')
        for nc in newCells
          # Desired cell is out of bounds or already occupied
          unless 0 <= nc[0] <= 21 && 0 <= nc[1] <= 9 && @grid.getCell(nc[0], nc[1]) == ' '
            for oc in oldCells
              @grid.setCell(oc[0], oc[1], '*')
            console.log('This is an invalid move')
            return false
        for nc in newCells
          @grid.setCell(nc[0], nc[1], '*')
        true

      moveLeft: ->
        console.log("left")
        if @move(@getAbsCells(@top, @left-1, @cells))
          @left--

      moveRight: ->
        if @move(@getAbsCells(@top, @left+1, @cells))
          @left++

      moveDown: ->
        if @move(@getAbsCells(@top+1, @left, @cells))
          @top++
        else
          # Find affected rows for line clear
          rows = []

          @generateBlock()

      lRotate: ->
        newCells = []
        for i in [0..3]
          newCells.push([])
          newCells[i].push(@cells[i][0])
          newCells[i].push(@cells[i][1])
        for i in [0..3]
          # (x, y) => (-y, x)
          tmp = newCells[i][0]
          newCells[i][0] = newCells[i][1] * -1
          newCells[i][1] = tmp
        if @move(@getAbsCells(@top, @left, newCells))
          @cells = newCells

      rRotate: ->
        newCells = []
        for i in [0..3]
          newCells.push([])
          newCells[i].push(@cells[i][0])
          newCells[i].push(@cells[i][1])
        for i in [0..3]
          # (x, y) => (y, -x)
          tmp = newCells[i][1]
          newCells[i][1] = newCells[i][0] * -1
          newCells[i][0] = tmp
        if @move(@getAbsCells(@top, @left, newCells))
          @cells = newCells

      getAbsCells: (top, left, cells) ->
        absCells = []
        for i in [0..3]
          absCells.push([])
          absCells[i].push(top + cells[i][0])
          absCells[i].push(left + cells[i][1])
          #console.log((top + cells[i][0]) + " " + (left + cells[i][1]))
        absCells

      iBlock: ->
        @top = 0.5
        @left = 4.5
        @cells =
          [ [-0.5, -1.5],
            [-0.5, -0.5],
            [-0.5, 0.5],
            [-0.5, 1.5] ]
        @move(@getAbsCells(@top, @left, @cells))
        # ______
        # |    |
        # |####|
        # |    |
        # |    |
        # ------

      jBlock: ->
        @top = 0
        @left = 4
        @cells =
          [ [0, -1],
            [0, 0],
            [0, 1],
            [1, 1] ]
        @move(@getAbsCells(@top, @left, @cells))
        # _____
        # |   |
        # |###|
        # |  #|
        # -----

      lBlock: ->
        @top = 0
        @left = 4
        @cells =
          [ [0, -1],
            [0, 0],
            [0, 1],
            [1, -1] ]
        @move(@getAbsCells(@top, @left, @cells))
        # _____
        # |   |
        # |###|
        # |#  |
        # -----

      oBlock: ->
        @top = 0.5
        @left = 4.5
        @cells =
          [ [-0.5, -0.5],
            [-0.5, 0.5],
            [0.5, -0.5],
            [0.5, 0.5] ]
        @move(@getAbsCells(@top, @left, @cells))
        # ____
        # |##|
        # |##|
        # ----

      sBlock: ->
        @top = 1
        @left = 4
        @cells =
          [ [-1, 0],
            [-1, 1],
            [0, -1],
            [0, 0] ]
        @move(@getAbsCells(@top, @left, @cells))
        # _____
        # | ##|
        # |## |
        # |   |
        # -----

      tBlock: ->
        @top = 0
        @left = 4
        @cells =
          [ [0, -1],
            [0, 0],
            [0, 1],
            [1, 0] ]
        @move(@getAbsCells(@top, @left, @cells))
        # _____
        # |   |
        # |###|
        # | # |
        # -----

      zBlock: ->
        @top = 1
        @left = 4
        @cells =
          [ [-1, -1],
            [-1, 0],
            [0, 0],
            [0, 1] ]
        @move(@getAbsCells(@top, @left, @cells))
        # _____
        # |## |
        # | ##|
        # |   |
        # -----
    return Block
])
