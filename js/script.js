/* Author: Eric Koslow

*/

$(function() {
  jQuery.timeago.settings.strings.hours = "not so long"
  jQuery("time.timeago").timeago();

  var bindNext = function() {
    $("#next").appear(function() {
      var self = this;
      $(self).fadeOut(function() {
        $.get($("#next a").attr('href'), function(data) {
          $(self).remove();
          $("#main").append($(data).find("#posts"));
          rebind();
        });
      });
    });
  },

  rebind = function() {
    bindNext();
    $("time.timeago").timeago();
    $('pre code').each(function(i, e) {hljs.highlightBlock(e, '    ')});
  }

  // MAIN LOOP
  rebind();
});
