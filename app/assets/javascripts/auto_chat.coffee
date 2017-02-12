$(document).ready ->
  delay = parseInt($('#chat_window_delay').val())
  setTimeout (-> ChatWindow.open()), delay*1000