$(document).on 'turbolinks:load', ->
  #  no_messages = $('#no_messages')[0].value == 'true'
  #  values_closeness = $('#values_closeness')[0].value == 'true'
  #  console.log no_messages
  #  console.log values_closeness
  #  if no_messages and values_closeness
  setTimeout (->
    ChatWindow.open();
  ), 2000
