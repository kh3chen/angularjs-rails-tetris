angular.module 'tetris', [
  'tetris-model'
  'tetris-controller'
]
.run([
  '$rootScope'
  ($rootScope) ->
    $rootScope.greeting = 'Hello'
    $rootScope.recipient = 'World'
    console.log("rootScope")
])
