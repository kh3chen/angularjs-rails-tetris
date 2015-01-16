angular.module('tetris-controller', ['tetris-model'])
.controller('tetrisCtrl', [
  '$rootScope', '$scope', '$interval', '$timeout', 'Game', 'Grid', 'Block',
  ($rootScope, $scope, $interval, $timeout, Game, Grid, Block) ->
      Game.init()

      tick = ->
        console.log(Grid.delay)
        console.log(Grid.level)
        if Grid.gameState == 2
          $rootScope.gameOverText = "Game Over! Press R to restart."
          return
        Block.moveDown()
        $rootScope.level = Grid.level
        $rootScope.score = Grid.score
        $rootScope.next_block = Block.blockQueue[0]
        $rootScope.tetris_game = Grid.drawText()
        $scope.images = Grid.getImages()
        $timeout tick, Grid.delay

      $scope.keyEvent = ($event)->
        if Grid.gameState == 0
          Game.start()
          $rootScope.tetris_game = Grid.drawText()
          $scope.images = Grid.getImages()
          tick()
          return
        else if Grid.gameState == 2
          if $event.keyCode == 82
            $rootScope.gameOverText = ""
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
         $rootScope.tetris_game = Grid.drawText()
         $scope.images = Grid.getImages()

      $rootScope.tetris_game = Grid.drawText()
      $scope.images = Grid.getImages()


      #handle keypress and trigger repaint

])
