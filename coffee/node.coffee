express = require 'express'
socket = require 'socket.io'
jade = require 'jade'

app = express()
http = require('http').Server(app)
io = socket(http);

views = []
views['index'] = jade.compileFile "#{__dirname}/view/index.jade"

app.get '/', (req, res) ->
  data =
    hello:'hello2'
  res.send( views['index'] data )

io.emit 'send:msg', for: 'everyone'
io.on 'connection',
  (thread) ->
    console.log 'a user connected'
    thread.on 'send:msg',
      (msg) ->
        thread.broadcast.emit 'send:msg', msg
        console.log "received #{msg}"

app.use '/static',
  express.static "#{__dirname}/public"

http.listen 1337,
  -> console.log 'Server running at http://127.0.0.1:1337/'
