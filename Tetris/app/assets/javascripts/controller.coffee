angular.module('tetris-controller', ['tetris-model'])
.controller('tetrisCtrl', [
  '$rootScope', '$scope', '$interval', '$timeout', 'Game', 'Grid', 'Block',
  ($rootScope, $scope, $interval, $timeout, Game, Grid, Block) ->
      console.log "tetris-controller"
      Game.init()
      Game.start()

      tick = ->
        console.log("tick")
        $rootScope.count++
        Block.moveDown()
        $rootScope.tetris_game = Grid.drawText()

      $scope.keyEvent = ($event)->
        console.log ($event.keyCode)
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
      $interval tick, 500

      #handle keypress and trigger repaint

])
