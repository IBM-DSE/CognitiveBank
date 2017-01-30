$(document).on 'turbolinks:load', ->
  $("#chat-button").click ->
    $( "#watson-button" ).toggle()
    $( "#close-button" ).toggle()
    $( "#chat-window" ).toggle()