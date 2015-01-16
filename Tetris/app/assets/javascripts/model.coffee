angular.module('tetris-model', [])

.factory('Game', [
  'Grid', 'Block'
  (Grid, Block)->
    init: ->
      @reset()

    reset: ->
      Grid.init()
      Block.init()


    start: ->
      Block.generateBlock()
      Grid.gameState = 1

])

.factory('Grid', [
  ()->
    init: ->
      @gameState = 0
      # 0: New game, game inactive
      # 1: Generate block, check if the newly generated block collides with anything
      # 2: Game over state
      @delay = 1000
      @lpl = 1  #Lines per level
      @linesCleared = 0
      @level = 1
      @score = 0
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

    getImages: ->
      images = []
      for i in [0..21]
        images.push([])
        for j in [0..9]
          if @cells[i][j] == ' '
            images[i].push("http://i.imgur.com/G6wBMhi.png")
          else
            images[i].push("http://i.imgur.com/vkJGOxR.png")
      return images

    getCell: (row, column) ->
      @cells[row][column]

    setCell: (row, column, value) ->
      @cells[row][column] = value

    setCells: (cells, value) ->
      for c in cells
        @cells[cells[0]][cells[1]] = value

    clearLines: (rows) ->
      fullRows = []
      rows = rows.sort()
      console.log(rows)
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
      @blockBag = []
      @value = ''

     generateBlock: ->
      if @blockBag.length == 0
        @blockBag = ['I', 'I', 'I', 'I',
                    'J', 'J', 'J', 'J',
                    'L', 'L', 'L', 'L',
                    'O', 'O', 'O', 'O',
                    'S', 'S', 'S', 'S',
                    'T', 'T', 'T', 'T',
                    'Z', 'Z', 'Z', 'Z' ]
      rand = Math.floor(Math.random()*@blockBag.length)
      switch @blockBag[rand]
      # Keyword usage error on case. Lookup switch & case on CoffeeScript
        when 'I' then @iBlock()
        when 'J' then @jBlock()
        when 'L' then @lBlock()
        when 'O' then @oBlock()
        when 'S' then @sBlock()
        when 'T' then @tBlock()
        when 'Z' then @zBlock()
      @blockBag.splice(rand, 1)
      console.log(@blockBag)
      unless @move(@getAbsCells(@top, @left, @cells), true)
        Grid.gameState = 2
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
        return true
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
        linesCleared = Grid.clearLines(rows)
        Grid.linesCleared += linesCleared
        Grid.level = Math.floor(Grid.linesCleared / Grid.lpl)
        Grid.score += 50 * linesCleared * Grid.level + Math.floor(@top)
        Grid.delay = Math.max(1000 - Grid.level* 100, 100)
        unless @gameState == 2
          @generateBlock()
        return false

    drop: ->
      while @moveDown()
        true


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
