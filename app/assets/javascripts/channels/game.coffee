App.game = App.cable.subscriptions.create "GameChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    @printMessage("Waiting for opponent ...")

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    switch data.action
      when "game_start"
        App.board.position("start")
        App.board.orientation(data.msg)
        @printMessage("Game started! You play as #{data.msg}.")
      when "make_move"
        [source, target] = data.msg.split("-")

        App.board.move(data.msg)
        App.chess.move
          from: source
          to: target
          promotion: "q"
      when "opponent_forfeits"
        @printMessage("Opponent forfeits. You win!")

  make_move: ->
    @perform 'make_move'

  printMessage: (message) ->
    $("#messages").append("<p>#{message}</p>")
