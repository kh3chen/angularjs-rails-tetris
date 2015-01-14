angular.module('tetris-controller', ['tetris-model'])
.controller('tetrisCtrl', [
  '$rootScope', '$scope', '$interval', 'Game', 'Grid', 'Block',
  ($rootScope, $scope, $interval, Game, Grid, Block) ->
    class TetrisController
      constructor: ($scope) ->
        console.log "TetrisController constructor"
        $scope.game = new Game
        $interval @repaint, 1000

      repaint: ->
        $rootScope.tetris_game = $scope.game.grid.drawText()
        $scope.game.grid.setCell(
          Math.floor(Math.random()*22),
          Math.floor(Math.random()*10),
          '*'
        )

    return new TetrisController $scope

])
