angular.module('tetris-model', [])

.factory('Game', [
  'Grid', 'Block'
  (Grid, Block)->
    init: ->
      @reset()

    reset: ->
      Grid.init()
      Block.init()
      @gameState = 0
      # 0: New game, game inactive
      # 1: Generate block, check if the newly generated block collides with anything
      # 2: Game over state

    start: ->
      Block.generateBlock()
      @gameState = 1

])

.factory('Grid', [
  ()->
    init: ->
      @linesCleared = 0
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

    clearLines: (rows) ->
      fullRows = []
      for r in rows
        lineFull = true
        for j in [0..9]
          if @cells[r][j] == ' '
            lineFull = false
            break
        if lineFull
          fullRows.push(r)

      for fr in fullRows
        for i in [fr..1]
          for j in [0..9]
            @cells[i][j] = @cells[i-1][j]
        for j in [0..9]
          @cells[0][j] = ' '

      return fullRows.length
])

.factory('Block', [
  #'Grid', 'dispatcher',
  'Grid',
  #(Grid, dispatcher)->
  (Grid)->
    init: ->
      @top = 0      # Add to cell row (i)
      @left = 0     # Add to cell col (j)
      @cells = []   # This is relative to the box
      @value = ''

     generateBlock: ->
      rand = Math.floor(Math.random()*7)
      switch rand
      # Keyword usage error on case. Lookup switch & case on CoffeeScript
        when 0 then @iBlock()
        when 1 then @jBlock()
        when 2 then @lBlock()
        when 3 then @oBlock()
        when 4 then @sBlock()
        when 5 then @tBlock()
        when 6 then @zBlock()
      unless @move(@getAbsCells(@top, @left, @cells), true)
        @gameState = 2
        #dispatcher.trigger 'new_highscore' {"Player", @linesCleared}


    move: (newCells, newBlock=false) ->
      unless newBlock
        oldCells = @getAbsCells(@top, @left, @cells)
        for oc in oldCells
          Grid.setCell(oc[0], oc[1], ' ')
      for nc in newCells
        # Desired cell is out of bounds or already occupied
        unless 0 <= nc[0] <= 21 && 0 <= nc[1] <= 9 && Grid.getCell(nc[0], nc[1]) == ' '
          unless newBlock
            for oc in oldCells
              Grid.setCell(oc[0], oc[1], @value)
          return false
      for nc in newCells
        Grid.setCell(nc[0], nc[1], @value)
      true

    moveLeft: ->
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
        for c in @cells
          unvisited = true
          for r in rows
            if @top + c[0] == r
              unvisited = false
              break
          if unvisited then rows.push(@top + c[0])
        Grid.linesCleared += Grid.clearLines(rows)
        unless @gameState == 2
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
      else if @move(@getAbsCells(@top, @left+1, newCells))
        @left++
        @cells = newCells
      else if @move(@getAbsCells(@top, @left-1, newCells))
        @left--
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
      @value = 'I'
      @top = 0.5
      @left = 4.5
      @cells =
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
      @value = 'J'
      @top = 0
      @left = 4
      @cells =
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
      @value = 'L'
      @top = 0
      @left = 4
      @cells =
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
      @value = 'O'
      @top = 0.5
      @left = 4.5
      @cells =
        [ [-0.5, -0.5],
          [-0.5, 0.5],
          [0.5, -0.5],
          [0.5, 0.5] ]
      # ____
      # |##|
      # |##|
      # ----

    sBlock: ->
      @value = 'S'
      @top = 1
      @left = 4
      @cells =
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
      @value = 'T'
      @top = 0
      @left = 4
      @cells =
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
      @value = 'Z'
      @top = 1
      @left = 4
      @cells =
        [ [-1, -1],
          [-1, 0],
          [0, 0],
          [0, 1] ]
      # _____
      # |## |
      # | ##|
      # |   |
      # -----
])
