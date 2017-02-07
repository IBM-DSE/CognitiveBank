window.ChatWindow = {};

is_visible = -> $('#chat-window').is(':visible')

toggle = ->
  $('#watson-button').toggle()
  $('#close-button').toggle()
  $('#chat-window').toggle()
  if is_visible()
    ready_input()
  
scroll_down = ->
  mydiv = $('#chat-flow');
  mydiv.scrollTop(mydiv.prop('scrollHeight'));
  
ready_input = ->
  scroll_down()
  $('#chat-input').focus()

ChatWindow.open = ->
  toggle() unless is_visible()

ChatWindow.received_message = ->
  $('#chat-input').attr('placeholder', 'Send a message...')
  $('#chat-input').prop('disabled', false);
  ready_input()

$(document).on 'turbolinks:load', ->
  $('#chat-button').click ->
    toggle()
    
  $("#new_message").bind "ajax:send", (event, xhr, status)->
    $('#chat-input').prop('disabled', true)
    $('#chat-input').val('')
    $('#chat-input').attr('placeholder', 'Sending...')