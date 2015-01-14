angular.module('tetris-controller', ['tetris-model'])
.controller('tetrisCtrl', [
  '$scope', '$interval', 'Game', 'Grid', 'Block',
  ($scope, $interval, Game, Grid, Block) ->
    class TetrisController
      constructor: ($scope) ->
        console.log "TetrisController constructor"
        $scope.game = new Game
        $interval @repaint, 1000

      repaint: ->
        console.log $scope.game.grid.drawText()

    return new TetrisController $scope

])
