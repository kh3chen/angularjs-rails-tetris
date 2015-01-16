angular.module('tetris-controller', ['tetris-model'])
.controller('tetrisCtrl', [
  '$rootScope', '$scope', '$interval', '$timeout', 'Game', 'Grid', 'Block',
  ($rootScope, $scope, $interval, $timeout, Game, Grid, Block) ->
      Game.init()

      tick = ->

        console.log("tick")
        $rootScope.count++
        Block.moveDown()
        $rootScope.lines_cleared = Grid.linesCleared
        $rootScope.tetris_game = Grid.drawText()

      $scope.keyEvent = ($event)->
        if Game.gameState == 0
          Game.start()
          $rootScope.tetris_game = Grid.drawText()
          $interval tick, 500
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
         $rootScope.tetris_game = Grid.drawText()

      $rootScope.tetris_game = Grid.drawText()


      #handle keypress and trigger repaint

])
