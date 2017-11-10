# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("form[data-remote]").on "ajax:success", (e, data, status, xhr) ->
    html = ''
    if data.prediction
      html += "<span class=\"label label-danger\" style=\"font-size: 240%;\">FRAUD</span> "
    else
      html += "<span class=\"label label-success\" style=\"font-size: 180%;\">Legitimate</span> "
    html += "<button type='button' class='btn btn-info' data-toggle='collapse' data-target='#response-"+data.id+"'>ML Response</button>\n" +
      "        <div id='response-"+data.id+"' class='collapse'><pre>"+JSON.stringify(data, null, 2)+"</pre></div>"
    $("#fraud-"+data.id).html html