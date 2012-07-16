/* Author: Eric Koslow

*/

$(function() {
  jQuery("time.timeago").timeago();
  // Creating custom :internal selector
  $.expr[':'].internal = function(obj){
    return !obj.href.match(/^mailto\:/) && (obj.hostname === location.hostname);
  };
  changeLocation = function() {
    var l = location.hash.split('!/')[1] || '/';
    $("#main").fadeOut(function() {
      // Add the loading splash
      $("body").prepend(
        $("<div />").attr('id', 'loading').text("Loading")
        .css('top', (window.innerHeight / 2) - (55 / 2))
        .css('left', (window.innerWidth / 2) - (200 / 2))
      );
      var self = this;
      $(self).empty(); // Remove #main content
      $.get('ajax/'+l, function(data) { //Grab AJAX content
        _gaq.push(['_trackPageview', '/#!/'+l]); //Track Ajax Pages in Google analytics
        update(data);
      }).error(function(data) { 
        update(data.responseText);
      });
    }); 
  }
  bindA = function() {
    $('a:internal').unbind('click.a').bind('click.a', function(e) {
      if(location.pathname === '/') {
        location.hash = '!'+$(this).attr('href');
        return false;
      }
    });
  }
  bindNext = function() {
    $("#next").appear(function() {
      var self = this;
      $(self).fadeOut(function() {
        $.get('ajax'+$("#next a").attr('href'), function(data) {
          $(self).remove();
          $("#main").append(data);
          rebind();
        });
      });
    });
  }
  rebind = function() {
    if("onhashchange" in window) { //Just use regular links if not a modern browser
      $(window).unbind('hashchange.b').bind('hashchange.b', changeLocation);
      bindA();
    }
    bindNext();
    $('pre code').each(function(i, e) {hljs.highlightBlock(e, '    ')});
  }
  update = function(html) {
    $("#main").html(html); //Set #main content
    rebind();
    $("#loading").remove(); // Remove the loading splash
    $("#main").fadeIn(); // Apear the new content
  }


  // MAIN LOOP
  rebind();
  if(location.hash && location.hash !== '#!/') {
    changeLocation();
  }
});
