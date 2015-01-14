angular.module('tetris-controller', ['tetris-model'])
.controller('tetrisCtrl', [
  '$rootScope', '$scope', '$interval', 'Game', 'Grid', 'Block',
  ($rootScope, $scope, $interval, Game, Grid, Block) ->
    class TetrisController
      constructor: ($scope) ->
        console.log "TetrisController constructor"
        $scope.game = new Game
        #$interval @repaint, 1000
        @repaint()

      repaint: ->

        $scope.game.generateBlock()
        $rootScope.tetris_game = $scope.game.grid.drawText()

    return new TetrisController $scope

])
