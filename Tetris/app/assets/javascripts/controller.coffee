angular.module('tetris-controller', ['tetris-model'])
.controller('tetrisCtrl', [
  '$rootScope', '$scope', '$interval', 'Game', 'Grid', 'Block',
  ($rootScope, $scope, $interval, Game, Grid, Block) ->
    class TetrisController
      constructor: ($scope) ->
        console.log "TetrisController constructor"
        $scope.game = new Game
        $scope.game.generateBlock()
        $interval @repaint, 1000

      repaint: ->
        $rootScope.tetris_game = $scope.game.grid.drawText()
        $scope.game.block.down()

    return new TetrisController $scope

])
