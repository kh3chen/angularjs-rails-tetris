angular.module 'tetris', [
  'tetris-model'
  'tetris-controller'
]
.run([
  '$rootScope'
  ($rootScope) ->
    $rootScope.greeting = 'Tetris'
    $rootScope.recipient = 'Let\'s Play'
    console.log("rootScope")
])
