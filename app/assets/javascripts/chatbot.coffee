scroll_down = ->
  mydiv = $("#chat-flow");
  mydiv.scrollTop(mydiv.prop("scrollHeight"));

$(document).on 'turbolinks:load', ->
  $("#chat-button").click ->
    $( "#watson-button" ).toggle()
    $( "#close-button" ).toggle()
    $( "#chat-window" ).toggle()
    do scroll_down if $( "#chat-window" ).is(':visible')
    