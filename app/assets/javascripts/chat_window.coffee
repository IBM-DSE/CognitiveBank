window.ChatWindow = {};

ChatWindow.is_visible = ->
  $('#chat-window').is(':visible')

ChatWindow.scroll_down = ->
  mydiv = $('#chat-flow');
  mydiv.scrollTop(mydiv.prop('scrollHeight'));

ChatWindow.toggle = ->
  $('#watson-button').toggle()
  $('#close-button').toggle()
  $('#chat-window').toggle()
  if ChatWindow.is_visible()
    ChatWindow.scroll_down()
    $('#chat-input').focus()

ChatWindow.open = ->
  ChatWindow.toggle() unless ChatWindow.is_visible()
  

$(document).on 'turbolinks:load', ->
  $('#chat-button').click ->
    ChatWindow.toggle()
  
  