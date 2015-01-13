angular.module('tetris-controller', ['tetris-model'])
.controller('tetrisCtrl', [
  '$scope', 'Grid', 'Block'
  ($scope) ->
    class TetrisController
      constructor: ($scope) ->
        @grid = new Grid
        @block = new Block(@grid)
        $scope.greeting = "Controller"

      repaint: ->


])
