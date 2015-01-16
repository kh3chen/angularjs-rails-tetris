angular.module('tetris-controller', ['tetris-model'])
.controller('tetrisCtrl', [
  '$scope', '$interval', '$timeout', 'Game', 'Grid', 'Block',
  ($scope, $interval, $timeout, Game, Grid, Block) ->
      Game.init()

      update = ->
        $scope.level = Grid.level
        $scope.score = Grid.score
        $scope.next_blocks = Block.getNextBlocks()
        $scope.tetris_game = Grid.drawText()
        $scope.images = Grid.getImages()


      tick = ->
        console.log(Grid.delay)
        console.log(Grid.level)
        if Grid.gameState == 2
          $scope.gameOverText = "Game Over! Press R to restart."
          return
        Block.moveDown()
        update()
        $timeout tick, Grid.delay

      $scope.keyEvent = ($event)->
        if Grid.gameState == 0
          Game.start()
          update()
          tick()
          return
        else if Grid.gameState == 2
          if $event.keyCode == 82
            console.log("Pressed R when game over")
            $scope.gameOverText = ""
            Game.init()
            Game.start()
            tick()
          return

        switch $event.keyCode
          when 37 #left
            Block.moveLeft()
          when 38 #up
            Block.rRotate()
          when 39 #right
            Block.moveRight()
          when 40 #down
            Block.moveDown()
          when 90
            Block.lRotate()
          when 88
            Block.rRotate()
          when 32
            Block.drop()
         update()

      update()
])
