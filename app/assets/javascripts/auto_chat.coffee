window_popup = null

$(document).ready ->
  delay = parseInt($('#chat_window_delay').val())
  window_popup = setTimeout (-> ChatWindow.open()), delay*1000

window.onbeforeunload = ->
  clearTimeout window_popup
