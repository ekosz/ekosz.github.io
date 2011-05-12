/* Author: Eric Koslow

*/

$(function() {
  // Creating custom :internal selector
  $.expr[':'].internal = function(obj){
    return !obj.href.match(/^mailto\:/) && (obj.hostname === location.hostname);
  };
  changeLocation = function() {
    var l = location.hash.split('!/')[1] || '/';
    console.log(l);
    $("#main").fadeOut(function() {
      var self = this;
      $(self).empty();
      $.get('ajax/'+l, function(data) {
        $(self).html(data);
        bindA();
        bindNext();
        $('pre code').each(function(i, e) {hljs.highlightBlock(e, '    ')});
      });
      $(self).fadeIn();
    }); 
  }
  bindA = function() {
    $('a:internal').click(function(e) {
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
          bindA();
        });
      });
    });
  }


  $(window).bind('hashchange', changeLocation);


  // MAIN LOOP
  bindA();
  bindNext();
  $('pre code').each(function(i, e) {hljs.highlightBlock(e, '    ')});
  if(location.hash && location.hash !== '#!/') {
    changeLocation();
  }
});
