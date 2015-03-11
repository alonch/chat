app = angular.module 'app', []
app.factory 'socket',
  ($rootScope) ->
    socket = io.connect()
    return instance =
      on: (eventName, callback) ->
        socket.on eventName, ->
          args = arguments
          $rootScope.$apply -> callback?.apply socket, args
      emit: (eventName, data, callback) ->
        socket.emit eventName, data, ->
          args = arguments
          $rootScope.$apply -> callback?.apply socket, args

app.controller 'msnCtrl', ['socket', '$scope', (socket, $scope) ->
  $scope.msgs = []
  socket.on 'send:msg', (msg) ->
    console.log msg
    $scope.msgs.push(msg)

  $scope.send = ->
    $scope.msgs.push($scope.msg)
    socket.emit('send:msg', $scope.msg)
    $scope.msg = ''
]
