angular.module('tetris-controller', ['tetris-model'])
.controller('tetrisCtrl', [
  '$rootScope', '$scope', '$interval', '$timeout', 'Game', 'Grid', 'Block',
  ($rootScope, $scope, $interval, $timeout, Game, Grid, Block) ->
      console.log "tetris-controller"
      $scope.game = new Game
      $scope.game.start()

      tick = ->
        console.log("tick")
        $rootScope.count++
        $scope.game.block.moveDown()
        $rootScope.tetris_game = $scope.game.grid.drawText()

      $scope.keyEvent = ($event)->
        console.log ($event.keyCode)
        switch $event.keyCode
          when 37 #left
            $scope.game.block.moveLeft()
          when 38 #up
            $scope.game.block.rRotate()
          when 39 #right
            $scope.game.block.moveRight()
          when 40 #down
            $scope.game.block.moveDown()
         $rootScope.tetris_game = $scope.game.grid.drawText()

      tick()
      $interval tick 500

      #handle keypress and trigger repaint

])
